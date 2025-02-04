# LinSolver-s390x-x86
An optimized RREF-based linear equation solver in s390x and x86 assembly.

## Overview
This project is an Assembly implementation of a matrix solver using Gaussian elimination. It reads a system of linear equations, converts the coefficient matrix into an upper triangular form, and computes the solutions.

## Features
- Reads an integer `N` representing the size of the matrix (NxN).
- Accepts floating-point inputs for the coefficient matrix (`A`) and the result vector (`B`).
- Performs Gaussian elimination to convert the matrix into an upper triangular form.
- Uses SIMD (AVX) instructions to optimize element swaps and row operations.
- Computes the solutions using back-substitution.
- Outputs the computed solution or an "Impossible" message if the system has no solution.

## Dependencies
- NASM (Netwide Assembler)
- GCC (for linking)
- x86-64 Linux environment with AVX support

## Compilation & Execution
1. Assemble the source code:
   ```sh
   nasm -f elf64 x86.asm -o x86.o
   ```
2. Link with GCC:
   ```sh
   gcc x86.o -o x86 -no-pie
   ```
3. Run the executable:
   ```sh
   ./x86
   ```

## Functions
### Input & Output
- `print_int` – Prints an integer.
- `print_float` – Prints a floating-point number with three decimal places.
- `print_char` – Prints a single character.
- `print_string` – Prints a null-terminated string.
- `print_nl` – Prints a newline character.
- `read_int` – Reads an integer from standard input.
- `read_float` – Reads a floating-point number.
- `read_char` – Reads a single character.

### Matrix Operations
- **Gaussian Elimination**: Transforms the coefficient matrix into an upper triangular form.
- **Row Swapping**: Moves the row with the largest pivot element to the top.
- **Back Substitution**: Solves for variables once the matrix is in row echelon form.
- **SIMD Optimization**: Uses AVX instructions for efficient row operations.

## Memory Layout
- `A` – The coefficient matrix, stored as a 1D array of `dq` (double-precision floats).
- `B` – The result vector.
- `N` – The matrix dimension.
- `res` – The solution vector.
- `remainder` – A temporary storage variable for vectorized operations.

## Author
Mehrshad Dehghani


