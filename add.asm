section .data
    promptFirst db "First number : "
    lenFirst equ $ - promptFirst

    promptSecond db "Second number : "
    lenSecond equ $ - promptSecond

    promptResult db "Result : "
    lenResult equ $ - promptResult

    negSign db "-"

    errMsg db "Invalid input!", 10
    errLen equ $ - errMsg

section .bss
    inputBuf resb 32

section .text
    global _start

_start:
    mov rdi, promptFirst
    mov rsi, lenFirst
    call print_str

    call read_num
    push rax

    mov rdi, promptSecond
    mov rsi, lenSecond
    call print_str

    call read_num

    pop rbx
    add rax, rbx

    push rax

    mov rdi, promptResult
    mov rsi, lenResult
    call print_str

    pop rax
    call print_num

    mov eax, 1
    xor ebx, ebx
    int 0x80

print_str:
    mov ecx, edi
    mov edx, esi
    mov ebx, 1
    mov eax, 4
    int 0x80
    ret

read_num:
    mov ecx, inputBuf
    mov edx, 32
    mov ebx, 0
    mov eax, 3
    int 0x80

    xor rax, rax
    mov rcx, inputBuf
    xor r8, r8
    xor r9, r9

    cmp byte [rcx], '-'
    jne .convertDigits

    mov r8, 1
    inc rcx

.convertDigits:
    movzx rbx, byte [rcx]

    cmp bl, 10
    je .finishRead

    cmp bl, '0'
    jl .invalidInput

    cmp bl, '9'
    jg .invalidInput

    inc r9
    sub bl, '0'

    imul rax, 10
    jo .invalidInput

    add rax, rbx
    jc .invalidInput

    inc rcx
    jmp .convertDigits

.finishRead:
    cmp r9, 0
    je .invalidInput

    cmp r8, 0
    je .returnValue

    neg rax

.returnValue:
    ret

.invalidInput:
    mov ecx, errMsg
    mov edx, errLen
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov eax, 1
    mov ebx, 1
    int 0x80

print_num:
    cmp rax, 0
    jge .positiveValue

    push rax

    mov ecx, negSign
    mov edx, 1
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop rax
    neg rax

.positiveValue:
    mov rbx, 10
    lea rsi, [inputBuf + 31]

    mov byte [rsi], 10
    dec rsi

.makeDigits:
    xor rdx, rdx
    div rbx

    add dl, '0'
    mov [rsi], dl

    dec rsi

    test rax, rax
    jnz .makeDigits

    inc rsi

    mov edx, inputBuf
    add edx, 32
    sub edx, esi

    mov ecx, esi
    mov ebx, 1
    mov eax, 4
    int 0x80
    ret
