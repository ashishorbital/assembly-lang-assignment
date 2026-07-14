default rel

section .data
    promptMain db "Input String: "
    lenPromptMain equ $ - promptMain

    promptTarget db "Input substring to be replaced: "
    lenPromptTarget equ $ - promptTarget

    promptReplace db "Input substring to replace: "
    lenPromptReplace equ $ - promptReplace

    msgReverse db "Reversed: ", 10
    lenReverse equ $ - msgReverse

    msgFinal db "Final: ", 10
    lenFinal equ $ - msgFinal

    newline db 10

section .bss
    mainBuf     resb 100
    targetBuf   resb 50
    replaceBuf  resb 50
    reverseBuf  resb 100
    finalBuf    resb 200

    mainLen     resq 1
    targetLen   resq 1
    replaceLen  resq 1
    reverseLen  resq 1
    finalLen    resq 1

section .text
    global _start

_start:
    mov rcx, promptMain
    mov rdx, lenPromptMain
    call printStr

    mov rcx, mainBuf
    mov rdx, 100
    call readStr
    mov [mainLen], rax
    mov [reverseLen], rax

    mov rcx, [mainLen]
    mov rsi, mainBuf
    add rsi, rcx
    dec rsi

    mov rdi, reverseBuf

.reverseLoop:
    cmp rcx, 0
    je .reverseDone

    std
    lodsb
    cld
    stosb

    dec rcx
    jmp .reverseLoop

.reverseDone:
    mov rcx, msgReverse
    mov rdx, lenReverse
    call printStr

    mov rcx, reverseBuf
    mov rdx, [reverseLen]
    call printStr
    call printNewline

    mov rcx, promptTarget
    mov rdx, lenPromptTarget
    call printStr

    mov rcx, targetBuf
    mov rdx, 50
    call readStr
    mov [targetLen], rax

    mov rcx, promptReplace
    mov rdx, lenPromptReplace
    call printStr

    mov rcx, replaceBuf
    mov rdx, 50
    call readStr
    mov [replaceLen], rax

    mov rsi, reverseBuf
    mov rdi, finalBuf

    mov qword [finalLen], 0
    xor rbx, rbx

.replaceLoop:
    cmp rbx, [reverseLen]
    jge .replaceDone

    mov rcx, [targetLen]
    test rcx, rcx
    jz .copyChar

    mov rdx, [reverseLen]
    sub rdx, rbx

    cmp rdx, rcx
    jl .copyChar

    push rsi
    push rdi

    mov rdi, targetBuf
    repe cmpsb
    jne .matchFailed

.matchFound:
    pop rdi
    add rsp, 8

    push rsi
    mov rsi, replaceBuf
    mov rcx, [replaceLen]

    cld
    rep movsb
    pop rsi

    mov rcx, [finalLen]
    add rcx, [replaceLen]
    mov [finalLen], rcx

    mov rcx, [targetLen]
    add rbx, rcx
    jmp .replaceLoop

.matchFailed:
    pop rdi
    pop rsi

.copyChar:
    cld
    movsb

    inc qword [finalLen]
    inc rbx
    jmp .replaceLoop

.replaceDone:
    mov rcx, msgFinal
    mov rdx, lenFinal
    call printStr

    mov rcx, finalBuf
    mov rdx, [finalLen]
    call printStr

    call printNewline

    mov eax, 1
    xor ebx, ebx
    int 0x80

    printStr:
    push rax
    push rbx

    mov eax, 4
    mov ebx, 1
    int 0x80

    pop rbx
    pop rax
    ret


readStr:
    push rbx

    mov eax, 3
    mov ebx, 0
    int 0x80

    dec rax

    pop rbx
    ret


printNewline:
    push rax
    push rbx
    push rcx
    push rdx

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
