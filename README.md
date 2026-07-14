# Assembly Language Programming Lab (NASM x86-64)

A collection of Assembly Language Programming (ALP) lab assignments implemented using **NASM (Netwide Assembler)** for **Linux x86-64**.

## Repository Structure

```
.
├── add.asm          # Addition of two signed integers
├── reverse.asm      # Reverse a string and replace a substring
├── matrix.asm       # Matrix multiplication
└── README.md
```

---

## Programs

### 1. Addition of Two Signed Numbers

**File:** `add.asm`

### Objective
Develop an Assembly Language Program to:
- Read two signed integers.
- Validate the input.
- Perform addition.
- Display the result.

### Features
- Supports positive and negative integers.
- Detects invalid inputs.
- Displays the sum.

### Sample Input
```
First number : 25
Second number : -10
```

### Sample Output
```
Result : 15
```

---

### 2. String Reverse and Substring Replacement

**File:** `reverse.asm`

### Objective
Develop an Assembly Language Program to:
- Read a string.
- Reverse the string.
- Replace a specified substring in the reversed string.
- Display the modified string.

### Features
- String reversal.
- Substring search.
- Substring replacement.
- Dynamic string processing.

### Sample Input
```
Input String: assembly
Input substring to be replaced: ylb
Input substring to replace: XYZ
```

### Sample Output
```
Reversed:
ylbmessa

Final:
XYZmessa
```

---

### 3. Matrix Multiplication

**File:** `matrix.asm`

### Objective
Develop an Assembly Language Program to perform multiplication of two square matrices.

### Features
- User-defined matrix size.
- Reads two matrices.
- Computes matrix multiplication.
- Displays the resultant matrix.

### Sample Input
```
Matrix Size: 2

Matrix A
1 2
3 4

Matrix B
5 6
7 8
```

### Sample Output
```
Result

19 22
43 50
```

---

# Requirements

- Ubuntu/Linux
- NASM
- GNU Linker (ld)

Install NASM:

```bash
sudo apt update
sudo apt install nasm
```

---

# Compilation

## Assemble

```bash
nasm -f elf64 filename.asm -o filename.o
```

## Link

```bash
ld filename.o -o filename
```

## Execute

```bash
./filename
```

Example:

```bash
nasm -f elf64 add.asm -o add.o
ld add.o -o add
./add
```

---

# Learning Outcomes

These programs demonstrate:

- Linux system calls
- User input/output
- Integer arithmetic
- String manipulation
- Matrix operations
- Memory management
- Loops and conditional branching
- Procedures and modular programming

---

# Tools Used

- NASM
- Linux (Ubuntu)
- GNU Linker (`ld`)
- x86-64 Assembly Language

---

# Course

**Assembly Language Programming Laboratory**

B.Tech Computer Science and Engineering

---

# Author

**Ashish PS**

B.Tech Computer Science and Engineering

---

# License

This repository is intended for educational and academic purposes.
