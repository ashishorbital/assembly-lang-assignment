default rel

section .data
    msgSize db "Input the matrix dimension: ", 10
    lenSize equ $ - msgSize

    msgMatrix1 db "Input elements of matrix A: ", 10
    lenMatrix1 equ $ - msgMatrix1

    msgMatrix2 db "Input elements matrix B: ", 10
    lenMatrix2 equ $ - msgMatrix2

    msgOutput db "Result is:", 10
    lenOutput equ $ - msgOutput

    lineFeed db 10

    errText db "Input is invlaid", 10
    lenErrText equ $ - errText

section .bss
    matrixSize resq 1
    totalCells resq 1

    matrixA resq 400
    matrixB resq 400
    matrixC resq 400

    inputBuf resb 32

section .text
    global _start

_start:
    mov rsi, msgSize
    mov rdx, lenSize
    call printStr

    call readNum
    mov [matrixSize], rax

    imul rax, rax
    mov [totalCells], rax

    mov rsi, msgMatrix1
    mov rdx, lenMatrix1
    call printStr

    mov rcx, [totalCells]
    xor rdi, rdi

.inputMatrixA:
    push rcx
    push rdi

    call readNum

    pop rdi
    mov [matrixA + rdi*8], rax

    inc rdi

    pop rcx
    dec rcx
    jnz .inputMatrixA

    mov rsi, msgMatrix2
    mov rdx, lenMatrix2
    call printStr

    mov rcx, [totalCells]
    xor rdi, rdi

.inputMatrixB:
    push rcx
    push rdi

    call readNum

    pop rdi
    mov [matrixB + rdi*8], rax

    inc rdi

    pop rcx
    dec rcx
    jnz .inputMatrixB

    mov r8, [matrixSize]
    xor rsi, rsi

.rowStart:
    cmp rsi, r8
    jge .finishMultiply

    xor rdi, rdi

.columnStart:
    cmp rdi, r8
    jge .nextMatrixRow

    xor rbx, rbx
    xor rcx, rcx
    .computeDot:
    cmp rbx, r8
    jge .storeResult

    mov r10, rsi
    imul r10, r8
    add r10, rbx
    mov r11, [matrixA + r10*8]

    mov r10, rbx
    imul r10, r8
    add r10, rdi
    mov r12, [matrixB + r10*8]

    mov rax, r11
    imul rax, r12
    add rcx, rax

    inc rbx
    jmp .computeDot

.storeResult:
    mov r10, rsi
    imul r10, r8
    add r10, rdi

    mov [matrixC + r10*8], rcx

    inc rdi
    jmp .columnStart

.nextMatrixRow:
    inc rsi
    jmp .rowStart

.finishMultiply:
    mov rsi, msgOutput
    mov rdx, lenOutput
    call printStr

    mov r8, [matrixSize]
    xor rsi, rsi

.printRow:
    cmp rsi, r8
    jge .programExit

    xor rdi, rdi

.printColumn:
    cmp rdi, r8
    jge .rowDone

    mov r10, rsi
    imul r10, r8
    add r10, rdi

    mov rax, [matrixC + r10*8]

    push rsi
    push rdi
    push r8

    call printNumSpace

    pop r8
    pop rdi
    pop rsi

    inc rdi
    jmp .printColumn

.rowDone:
    push rsi
    push r8

    call printNewline

    pop r8
    pop rsi

    inc rsi
    jmp .printRow

.programExit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    printStr:
    mov rcx, rsi
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret


readNum:
    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuf
    mov edx, 32
    int 0x80

    xor rax, rax
    xor rbx, rbx

    mov rcx, inputBuf
    xor r9, r9

    cmp byte [rcx], '-'
    jne .readDigits

    mov r9, 1
    inc rcx

.readDigits:
    mov bl, [rcx]

    cmp bl, 10
    je .readDone

    cmp bl, '0'
    jl .invalid

    cmp bl, '9'
    jg .invalid

    sub bl, '0'

    imul rax, 10
    jo .invalid

    add rax, rbx
    jc .invalid

    inc rcx
    jmp .readDigits

.readDone:
    cmp r9, 1
    jne .returnValue

    neg rax

.returnValue:
    ret

.invalid:
    mov eax, 4
    mov ebx, 1
    mov ecx, errText
    mov edx, lenErrText
    int 0x80

    mov eax, 1
    mov ebx, 1
    int 0x80


printNumSpace:
    xor r9, r9

    cmp rax, 0
    jge .beginConvert

    mov r9, 1
    neg rax

.beginConvert:
    mov rsi, inputBuf
    add rsi, 31

    mov byte [rsi], 32
    dec rsi

    mov rbx, 10

.convertLoop:
    xor rdx, rdx
    div rbx

    add dl, '0'
    mov [rsi], dl

    dec rsi

    test rax, rax
    jnz .convertLoop

    cmp r9, 1
    jne .readyPrint

    mov byte [rsi], '-'
    dec rsi

.readyPrint:
    inc rsi

    mov rcx, rsi

    mov rdx, inputBuf
    add rdx, 32
    sub rdx, rcx

    mov eax, 4
    mov ebx, 1
    int 0x80

    ret


printNewline:
    push rax
    push rbx
    push rcx
    push rdx

    mov eax, 4
    mov ebx, 1
    mov ecx, lineFeed
    mov edx, 1
    int 0x80

    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret
