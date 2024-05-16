# ASM2COBOL

Cobol subprograms which can be used for certain HLASM instructions. For example, to replace an ASM program.

## Description

In this project, Cobol subroutines are bundled, which can perform HLASM (Assembler) instructions in Cobol. These programs are used to support the replacement of assembler programs.

## Documentation for subprograms
- [BITOPS](https://github.com/derDennis99/ASM2COBOL/tree/main/BITOPS)

## TSTPRG Documentation
### Overview
The TSTPRG program serves as the main program for testing subprograms. It reads an input file containing test cases for the subprograms and their expected results.

### Input File
The input file TSTIN contains test cases for the TSTPRG program. Each test case begins with a function identifier (FUNC) and is followed by fields specific to the subprogram being tested. The structure of the input data can vary depending on the subprogram, but the FUNC field remains consistent across all test cases.

### Example Input File TSTIN
```
* Test cases for TSTPRG
*
* Test for BITOPS:
*FUNC|INPUT   |MASK HEX|RESULT HEX
   OI A1       E0       E1
   NI 7C       6E       6C
   NI 1234     5678     1230
   NI 1234     E0       0020
```

### General Structure
FUNC: The function to be tested (e.g., OI for Or Immediate, NI for And Immediate).
Subprogram-Specific Fields: Additional fields required for the subprogram being tested. These fields can vary depending on the subprogram.

### TSTJCL
The JCL script, named TSTJCL, is used to compile and run the TSTPRG program and its subprograms. The script is designed to run on an IBM test system.

## Authors

Contributors names and contact info

[@derDennis99](https://github.com/derDennis99)
[@Denroc92](https://github.com/Denroc92)

## Version History

* 0.1
    * Initial Release

## License

This project has no license and is freely available - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [IBM Documentation](https://www.ibm.com/docs/en)
* [Mainframe Assembler Mini-Reference](https://geraldine.fjfi.cvut.cz/~oberhuber/data/mainframe/prezentace/pmf/hlasmref.pdf)
* [370 Instructions](http://www.simotime.com/asmins01.htm)
