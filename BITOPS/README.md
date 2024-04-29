# BITOPS - Binary Operations Program

## Introduction
BITOPS is a program designed for performing bitwise operations on binary data. It allows users to apply logical operations such as OR and AND on binary input data using corresponding masks.

## Authors
- [@derDennis99](https://github.com/derDennis99)
- [@Denroc92](https://github.com/Denroc92)

## Usage
The program accepts two inputs:
1. **Input Data (I-C-INPUT)**: The binary data on which the operation will be performed.
2. **Mask (I-C-MASK)**: The binary mask used for the operation.

## Instructions
The program supports two types of operations:
- **OI (Or Inclusive)**: Sets the output bit to 1 if either the input data bit or the mask bit is 1.
- **NI (Not Inclusive)**: Sets the output bit to 1 only if both the input data bit and the mask bit are 1.

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

## Structure
BITOPS/
│
├── bitops.cbl (Main COBOL program)
│
├── BITOPS.txt (Transfer areas)
│
└── README.md (Documentation)

## Examples
```cobol```

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
