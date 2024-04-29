      *-----------------------
       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    BITOPS
       AUTHOR.        @derDennis99 @Denroc92.
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *-------------
       DATA DIVISION.
      *-------------
       FILE SECTION.
      *
       WORKING-STORAGE SECTION.

      *-----------------------------------------------------------------
      *    WORK VARIABLES
      *-----------------------------------------------------------------
       01 W1.
      *    **************
      *    * HEX FIELDS *
      *    **************
           05 W1-H-INPUT                 PIC X(4) JUST RIGHT.
           05 W1-H-MASK                  PIC X(4) JUST RIGHT.

      *    *****************
      *    * BINARY-FIELDS *
      *    *****************
           05 W1-BI-INPUT                PIC X(32).
           05 W1-BI-MASK                 PIC X(32).
           05 W1-BI-RESULT               PIC X(32).

      *    ***********
      *    * INDICES *
      *    ***********
           05 W1-I1                      PIC 999.
           05 W1-I2                      PIC 999.
           05 W1-RES-I                   PIC 9999.

      *    Start variables
           05 W1-START-I                 PIC 999.
           05 W1-START-LOOP-I            PIC 9999.

      *    **************************************
      *    * COUNTERS AND LENGHT SPECIFICATIONS *
      *    **************************************
           05 W1-BITS-COUNT              PIC 9(8) COMP.

      *    Maximum length of the input fields. (Is calculated in INIT!)
           05 W1-MAX-TXT-LEN             PIC 999.
           05 W1-MAX-HEX-LEN             PIC 999.
           05 W1-MAX-BIN-LEN             PIC 9999.

      *    Input fields content lengths
           05 W1-I-BYTES-LEN             PIC 999.
           05 W1-I-MASK-LEN              PIC 999.
      *-----------------------------------------------------------------

       LINKAGE SECTION.
      *-----------------------------------------------------------------
      *    TRANSFER AREAS
      *-----------------------------------------------------------------
       01 BITOPS-PGM.
      *    ****************
      *    * INPUT FIELDS *
      *    ****************
           05 I-C-INPUT                  PIC X(8).
           05 I-C-MASK                   PIC X(8).

           05 I-C-INSTRUCT               PIC X(2).
           88 I-B-INSTRUCT-VALID                     VALUES   'OI',
                                                              'NI'.
           88 I-B-INSTRUCT-OI                        VALUE    'OI'.
           88 I-B-INSTRUCT-NI                        VALUE    'NI'.

      *    *****************
      *    * OUTPUT FIELDS *
      *    *****************
           05 O-C-RESULT                 PIC X(8).
           05 O-H-RESULT                 PIC X(4).
           05 O-BI-RESULT                PIC X(32).

           05 O-N-RETURNCODE             PIC 99.
           88 O-B-RC-IO                              VALUE 00.
           88 O-B-RC-INPUT-LENGTH-ERROR              VALUE 06.
           88 O-B-RC-INSTRCT-UNKNOWN                 VALUE 10.
           88 O-B-RC-VAR-LENGTH-ERROR                VALUE 12.
      *-----------------------------------------------------------------

       PROCEDURE DIVISION USING          BITOPS-PGM.

       A00-MAIN SECTION.
      *    -------------------------------------------------------------
      *    Initializations and length calculations
      *    -------------------------------------------------------------
           PERFORM A01-INIT
      *    -------------------------------------------------------------
      *    Check inputs
      *    -------------------------------------------------------------
           PERFORM A02-INPUT-CHECK
      *    -------------------------------------------------------------
      *    Prepare input fields (STR -> HEX + BIN)
      *    -------------------------------------------------------------
           PERFORM A03-PREPARE-INPUT
      *    -------------------------------------------------------------
      *    Perform processing 
      *    -------------------------------------------------------------
           PERFORM B01-PROCESS
      *    -------------------------------------------------------------     
      *    Final processing (Write results to the output)
      *    -------------------------------------------------------------
           PERFORM B99-END

           CONTINUE.

       A01-INIT SECTION.

           SET O-B-RC-IO            TO TRUE

      *    -------------------------------------------------------------
      *    Calculate length content of input
      *    -------------------------------------------------------------
      *    I-C-INPUT
           MOVE 1               TO W1-I2
           MOVE ZERO            TO W1-I-BYTES-LEN
           PERFORM UNTIL W1-I2 > LENGTH OF I-C-INPUT
           OR I-C-INPUT(W1-I2:1) = SPACE
              ADD 1 TO W1-I2
              ADD 1 TO W1-I-BYTES-LEN
           END-PERFORM

      *    I-C-MASK
           MOVE 1               TO W1-I2
           MOVE ZERO            TO W1-I-MASK-LEN
           PERFORM UNTIL W1-I2 > LENGTH OF I-C-MASK
           OR I-C-MASK (W1-I2:1) = SPACE
              ADD 1 TO W1-I2
              ADD 1 TO W1-I-MASK-LEN
           END-PERFORM

           COMPUTE W1-BITS-COUNT = W1-I-BYTES-LEN / 2 * 8

      *    -------------------------------------------------------------
      *    Calculate maximum lengths
      *    -------------------------------------------------------------
           MOVE LENGTH OF I-C-INPUT            TO W1-MAX-TXT-LEN

           IF FUNCTION MOD(W1-MAX-TXT-LEN, 2) NOT = ZERO
           OR LENGTH OF I-C-INPUT NOT = LENGTH OF I-C-MASK
           THEN
              SET O-B-RC-VAR-LENGTH-ERROR      TO TRUE
              PERFORM B99-END
           END-IF

           COMPUTE W1-MAX-HEX-LEN         = W1-MAX-TXT-LEN / 2
           COMPUTE W1-MAX-BIN-LEN         = W1-MAX-HEX-LEN * 8

           CONTINUE.

       A02-INPUT-CHECK SECTION.
      *    Check is transfer length divisible by 2?
           IF FUNCTION MOD(W1-I-BYTES-LEN, 2) NOT = ZERO THEN
              SET O-B-RC-INPUT-LENGTH-ERROR     TO TRUE
              PERFORM B99-END
           END-IF

           IF W1-I-BYTES-LEN < W1-I-MASK-LEN
           THEN
              SET O-B-RC-INPUT-LENGTH-ERROR     TO TRUE
              PERFORM B99-END
           END-IF

      *    Check the set instruction. Program compatible?
           IF NOT I-B-INSTRUCT-VALID
              SET O-B-RC-INSTRCT-UNKNOWN        TO TRUE
              PERFORM B99-END
           END-IF
      
           CONTINUE.

       A03-PREPARE-INPUT SECTION.
      *    I-C-INPUT-> W1-H-INPUT -> W1-BI-INPUT
           MOVE FUNCTION HEX-TO-CHAR (I-C-INPUT(1:W1-I-BYTES-LEN))
                                TO W1-H-INPUT

           COMPUTE W1-START-I = W1-MAX-HEX-LEN
                              - (W1-I-BYTES-LEN / 2)

           INSPECT W1-H-INPUT(1:W1-START-I)
                                REPLACING ALL SPACES
                                BY LOW-VALUE

           MOVE FUNCTION BIT-OF(W1-H-INPUT) TO W1-BI-INPUT

      *    I-C-MASK -> W1-H-MASK -> W1-BI-MASK
           MOVE FUNCTION HEX-TO-CHAR (I-C-MASK(1:W1-I-MASK-LEN))
                                TO W1-H-MASK

           COMPUTE W1-START-I = W1-MAX-HEX-LEN
                              - (W1-I-MASK-LEN / 2)

           INSPECT W1-H-MASK(1:W1-START-I)
                                REPLACING ALL SPACES
                                BY LOW-VALUE

           MOVE FUNCTION BIT-OF(W1-H-MASK) TO W1-BI-MASK

           CONTINUE.

       B01-PROCESS SECTION.

           COMPUTE W1-START-LOOP-I = W1-MAX-BIN-LEN
                                   - W1-BITS-COUNT
                                   + 1

           MOVE 1                  TO W1-RES-I

           PERFORM VARYING W1-I1 FROM W1-START-LOOP-I BY 1
           UNTIL W1-I1> W1-MAX-BIN-LEN

              EVALUATE TRUE
      *          *** OI ***
                 WHEN  (I-B-INSTRUCT-OI AND
                       (W1-BI-INPUT(W1-I1:1)           = '1'
                       OR  W1-BI-MASK(W1-I1:1)         = '1'))
      *          *** NI ***
                 WHEN  (I-B-INSTRUCT-NI AND
                       (W1-BI-INPUT(W1-I1:1)           = '1'
                       AND W1-BI-MASK(W1-I1:1)         = '1'))
      *          **********
                    MOVE 1         TO W1-BI-RESULT(W1-RES-I:1)
                 WHEN OTHER
                    MOVE 0         TO W1-BI-RESULT(W1-RES-I:1)
              END-EVALUATE

              ADD 1                TO W1-RES-I

           END-PERFORM

           CONTINUE.

       B99-END SECTION.

      *    Write result to output
           INSPECT W1-BI-RESULT REPLACING ALL LOW-VALUES BY ZERO
           MOVE W1-BI-RESULT                         TO O-BI-RESULT
           MOVE FUNCTION BIT-TO-CHAR(W1-BI-RESULT)   TO O-H-RESULT
           MOVE FUNCTION HEX-OF(O-H-RESULT)          TO O-C-RESULT

           GOBACK.
