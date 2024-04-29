# BITOPS - Binary Operations Program

## Introduction
BITOPS is a program designed for performing bitwise operations on binary data. It allows users to apply logical operations such as OR and AND on binary input data using corresponding masks.

## Authors
- [@derDennis99](https://github.com/derDennis99)
- [@Denroc92](https://github.com/Denroc92)

## Usage
The program accepts two inputs:
1. **Input Data (I-C-INPUT)**: The hexadecimal data in text format on which the operation will be performed. For example, instead of "0", "F0" should be provided.
2. **Mask (I-C-MASK)**: The hexadecimal mask in text format used for the operation. For example, instead of "0", "F0" should be provided.

## Instructions
The program supports two types of operations:
- **OI (Or Immediate)**: Performs a bitwise OR operation between the input data and the mask.
- **NI (Not Immediate)**: Performs a bitwise AND operation between the input data and the mask.

## Output
The program produces three types of output:
1. **Binary Result (O-BI-RESULT)**: The binary result of the bitwise operation.
2. **Hexadecimal Result (O-H-RESULT)**: The hexadecimal representation of the binary result.
3. **Character Result (O-C-RESULT)**: The character representation of the hexadecimal result.

## Algorithm Overview
1. **Initialization**: Initializes variables and calculates the length of input data.
2. **Input Check**: Validates input lengths and instruction validity.
3. **Input Preparation**: Converts input data and mask from hexadecimal to binary format.
4. **Processing**: Performs the bitwise operation based on the specified instruction.
5. **Output**: Converts the binary result to hexadecimal and character formats for output.

## Examples
```
* Example 1
MOVE 'A1'             TO I-C-INPUT
MOVE 'E0'             TO I-C-MASK
SET I-B-INSTRUCT-OI   TO TRUE

CALL 'BITOPS' USING BITOPS-PGM

* Results (N = Null):
* TXT: E1000000
* HEX: ÷NNN
* BIN: 11100001000000000000000000000000

* Example 2
MOVE '7C'             TO I-C-INPUT
MOVE '6E'             TO I-C-MASK
SET I-B-INSTRUCT-NI   TO TRUE

CALL 'BITOPS' USING BITOPS-PGM

* Results (N = Null):
* TXT: 6C000000
* HEX: %NNN
* BIN: 01101100000000000000000000000000

* Example 3
MOVE '1234'           TO I-C-INPUT
MOVE '5678'           TO I-C-MASK
SET I-B-INSTRUCT-NI   TO TRUE

CALL 'BITOPS' USING BITOPS-PGM

* Results (N = Null):
* TXT: 12300000
* HEX: NN
* BIN: 00010010001100000000000000000000

* Example 4
MOVE '1234'           TO I-C-INPUT
MOVE 'E0'             TO I-C-MASK
SET I-B-INSTRUCT-NI   TO TRUE

CALL 'BITOPS' USING BITOPS-PGM

* Results (N = Null):
* TXT: 00200000
* HEX: NN
* BIN: 00000000001000000000000000000000
```

## Compilation and Execution
1. Compile the program using a COBOL compiler.
2. Execute the compiled binary, providing input data and mask as arguments.

## License
For the licenses, see main repository.

## Contributions
Contributions are welcome! Feel free to submit issues or pull requests.

## Support
For any questions or issues, please open an issue on GitHub.

## Disclaimer
This program is provided as-is, without any warranty. Use at your own risk.

## Acknowledgments
Special thanks to all contributors and supporters of this project. Your feedback and contributions are greatly appreciated!
