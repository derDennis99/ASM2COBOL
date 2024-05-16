*-----------------------
 IDENTIFICATION DIVISION.
*-----------------------
 PROGRAM-ID.    TSTPRG
 AUTHOR.        @derDennis99 @Denroc92.
*--------------------
 ENVIRONMENT DIVISION.
*--------------------
 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
     SELECT INPUT-LINE ASSIGN TO EING.
     SELECT PRINT-LINE ASSIGN TO OUT.
*-------------
 DATA DIVISION.
*-------------
 FILE SECTION.
 FD  INPUT-LINE RECORDING MODE F.
 01  INPUT-REC.
     05 FIRST-BYTE                 PIC X.
     88 FIRST-BYTE-COMMENT                     VALUE '*'.

     05 INPUT-FUNC                 PIC X(4).
     88 BITOPS                                 VALUE '  NI',
                                                     '  OI'.
     05 FILLER                     PIC X.
     05 INPUT-DATA                 PIC X(74).
*-----------------------------------------------------------------
*    INPUT FIELDS - BITOPS
*-----------------------------------------------------------------
     05 BITOPS-INPUT               REDEFINES INPUT-DATA.
     10 BO-I-INPUT                 PIC X(8).
     10 FILLER                     PIC X.
     10 BO-I-MASK                  PIC X(8).
     10 FILLER                     PIC X.
     10 BO-I-EXPECTED-RESULT       PIC X(8).
     10 FILLER                     PIC X(48).
*-----------------------------------------------------------------
*
 FD  PRINT-LINE RECORDING MODE F.
 01  PRINT-REC.
     05 OUT-LINE                   PIC X(80).
*
 WORKING-STORAGE SECTION.
*-----------------------------------------------------------------
*    TRANSFER AREAS FOR SUBPROGRAMS
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

*-----------------------------------------------------------------
*    WORK VARIABLES
*-----------------------------------------------------------------
 01 W01.
     05 EING                       PIC X.
     88 EING-EOF                               VALUE 'Y'.

     05 W1-CURRENT-TS              PIC X(16).

*    ***********
*    * INDICES *
*    ***********
     05 WS-INDEX                   PIC 99      VALUE 1.

*    **************************************
*    * COUNTERS AND LENGHT SPECIFICATIONS *
*    **************************************
     05 WS-LENGTH                  PIC 99      VALUE ZERO.
*-----------------------------------------------------------------

 LINKAGE SECTION.

*------------------
 PROCEDURE DIVISION.
*------------------

 A00-MAIN SECTION.

     OPEN INPUT  INPUT-LINE.
     OPEN OUTPUT PRINT-LINE.

     MOVE SPACE                        TO PRINT-REC
     MOVE FUNCTION CURRENT-DATE        TO W1-CURRENT-TS
     STRING 'TESTER START AT '
            W1-CURRENT-TS (1:4) '-'
            W1-CURRENT-TS (5:2) '-'
            W1-CURRENT-TS (7:2) ' '
            W1-CURRENT-TS (9:2) ':'
            W1-CURRENT-TS (11:2) ':'
            W1-CURRENT-TS (13:4)
            DELIMITED BY SIZE
            INTO PRINT-REC
     END-STRING
     INSPECT PRINT-REC REPLACING ALL LOW-VALUES BY SPACE
     WRITE PRINT-REC

     MOVE ALL '-'                      TO PRINT-REC
     WRITE PRINT-REC

     PERFORM A01-READ-EING

     PERFORM UNTIL EING-EOF

        IF NOT FIRST-BYTE-COMMENT
        THEN
           EVALUATE TRUE
              WHEN BITOPS
                 PERFORM B01-BITOPS-TEST
           END-EVALUATE
        END-IF

        PERFORM A01-READ-EING
     END-PERFORM

     MOVE ALL '-'                      TO PRINT-REC
     WRITE PRINT-REC

     MOVE SPACE                        TO PRINT-REC
     MOVE FUNCTION CURRENT-DATE        TO W1-CURRENT-TS
     STRING 'TESTER END   AT '
            W1-CURRENT-TS (1:4) '-'
            W1-CURRENT-TS (5:2) '-'
            W1-CURRENT-TS (7:2) ' '
            W1-CURRENT-TS (9:2) ':'
            W1-CURRENT-TS (11:2) ':'
            W1-CURRENT-TS (13:4)
            DELIMITED BY SIZE
            INTO PRINT-REC
     END-STRING
     INSPECT PRINT-REC REPLACING ALL LOW-VALUES BY SPACE
     WRITE PRINT-REC

     CLOSE INPUT-LINE.
     CLOSE PRINT-LINE.

     GOBACK.

 A01-READ-EING SECTION.

     READ INPUT-LINE
        AT END SET EING-EOF TO TRUE
     END-READ.

     CONTINUE.

 B01-BITOPS-TEST SECTION.

     PERFORM B01-BITOPS-SET-INPUT
     PERFORM B01-BITOPS-CALL
     PERFORM B01-BITOPS-PRINT-RESULT

     CONTINUE.

 B01-BITOPS-SET-INPUT SECTION.

     MOVE 1               TO WS-INDEX
     MOVE ZERO            TO WS-LENGTH
     PERFORM UNTIL WS-INDEX > LENGTH OF BO-I-INPUT
     OR BO-I-INPUT (WS-INDEX:1) = SPACE
        ADD 1 TO WS-INDEX
        ADD 1 TO WS-LENGTH
     END-PERFORM

     MOVE BO-I-INPUT    TO I-C-INPUT
     MOVE BO-I-MASK     TO I-C-MASK

     MOVE INPUT-FUNC(3:2)    TO I-C-INSTRUCT

     CONTINUE.

 B01-BITOPS-CALL SECTION.

     CALL 'BITOPS' USING BITOPS-PGM

     CONTINUE.

 B01-BITOPS-PRINT-RESULT SECTION.

*    Check Results
     IF O-B-RC-IO
     THEN
        IF BO-I-EXPECTED-RESULT (1:WS-LENGTH)
        =  O-C-RESULT (1:WS-LENGTH)
        THEN
           MOVE SPACE                  TO PRINT-REC
*          TEST PASSED
           STRING '(PASSED-BITOPS)-'O-N-RETURNCODE'-'
                  O-C-RESULT (1:WS-LENGTH) ' == '
                  BO-I-EXPECTED-RESULT (1:WS-LENGTH)
                  '|' O-C-RESULT
                  '|' O-H-RESULT
                  '|' O-BI-RESULT
                  DELIMITED BY SIZE
                  INTO PRINT-REC
           END-STRING
        ELSE
           MOVE SPACE                  TO PRINT-REC
*          TEST FAILED
           STRING '(FAILED-BITOPS)-'O-N-RETURNCODE'-'
                  O-C-RESULT (1:WS-LENGTH) ' != '
                  BO-I-EXPECTED-RESULT (1:WS-LENGTH)
                  DELIMITED BY SIZE
                  INTO PRINT-REC
           END-STRING
        END-IF

        WRITE PRINT-REC
     ELSE
        MOVE SPACE                     TO PRINT-REC
*       TEST FAILED
        STRING '(FAILED-BITOPS)-'O-N-RETURNCODE'-'
               I-C-INPUT'|'I-C-MASK'|'I-C-INSTRUCT
               DELIMITED BY SIZE
               INTO PRINT-REC
        END-STRING
        WRITE PRINT-REC
     END-IF

     CONTINUE.
