//TSTJCL JOB 1,NOTIFY=&SYSUID
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(BITOPS),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(BITOPS),DISP=SHR
//***************************************************/
// IF RC < 8 THEN
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(TSTPRG),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(TSTPRG),DISP=SHR
//LKED.SYSLIB  DD DSN=&SYSUID..LOAD(BITOPS),DISP=SHR
//***************************************************/
// IF RC < 8 THEN
//***************************************************/
//RUN     EXEC PGM=TSTPRG
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//EING      DD DSN=&SYSUID..EING(HPROEING),DISP=SHR
//OUT       DD SYSOUT=*,OUTLIM=15000
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
// ELSE
// ENDIF
