; Sandra Deutl - BZ84214
; Katheryne Lochart- MW24658
; CMSC 313 Project 4

extern scanf

section .data
numPrompt:      db "Enter a number between 2 and the total number of characters in the string: ", 0
numPromptLen:   equ $- numPrompt

resultStr:      db "Unedited String: ", 0
resultStrLen:   equ $- resultStr

calcStr:        db "Edited String: ", 0
calcStrLen:     equ $- calcStr

newLine:        db 10

section .bss
initialString:         resq 1
editedStr:       resd 1
num:            resd 1
strLen:         resq 1


section .text

global reverse
reverse:

    xor r8b, r8b
    xor r9, r9
    xor r12, r12
    xor r13, r13        ;just to make sure registers are null

    push rbp
    mov rbp, rsp
    
    xor r8, r8
    mov r8, rdi
    mov qword[initialString], r8

    mov rsi, r8
    mov rdi, editedStr

    mov rcx, 0
    mov rax, strLen
    dec rax

    call promptNum ; get number for splitting

    call checkNum ; check if the number is between 2 and strLen
    call printUnedited
    call reverseFirstHalf

    exor rdi, rdi
    mov rcx, rsi
    dec rcx

    call reverseSecondHalf
    call printEdited

    ret


promptNum:
    mov rax, 1
    mov rdi, 1
    mov rsi, numPrompt 
    mov rdx, numPromptLen
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 3
    syscall

checkNum:
    xor r9b, r9b        ;resetting to count the characters
    mov r10, num
    dec rax
    cmp rax, 1
    jg convertNumDouble
    jmp convertNumSingle

convertNumDouble:
    mov r8b, [r10]      ;moving to empty register
    sub r8b, 48
    mov al, 10
    mul r8
    add r9, rax         ;r9 stores temp number
    inc r10             ;moving to next digit

convertNumSingle:
    mov r8b, [r10]
    sub r8b, 48
    add r9b, r8b
    cmp r9b, 2
    jl promptNum
    cmp r9b, r12b
    jg promptNum
    dec r9b             


printUnedited:
    mov rax, 1
    mov rdi, 1
    mov rsi, resultStr
    mov rdx, resultStrLen
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, [initialString]
    xor rdx, rdx
    mov edx, dword[strLen]
    syscall

    call printNewLine

    ret

reverseFirstHalf:
    cmp rdi, num
    jae reverseSecondHalf

    mov al, [resultStr + rdi]
    mov [calcStr + rdi], al
    inc rdi
    jmp reverseFirstHalf


reverseSecondHalf:
    cmp rdi, num
    je revLoopComplete

    mov al, [resultStr + rdi]
    mov [calcStr + rbx + rcx - rdi], al
    inc rdi
    jmp reverseSecondHalf


reverseStrLoop:
    cmp rcx, rax
    jge revLoopComplete

    mov al, [rsi + rcx]
    mov [rdi], al
    inc rdi
    inc rcx
    jmp reverseStrLoop

revLoopComplete:
    mov rax, 4
    mov rbx, 1
    mov rcx, calcStr
    mov byte[rdi], 0

printEdited:
    mov rax, 1
    mov rdi, 1
    mov rsi, [calcStr]
    mov rdx, dword[calcStrLen]
    syscall

    call printNewLine

    mov r8b, r9b
    mov r13, string
    add r13, r9         ;i wanted to do r9b but it won't let me

    ret

printNewLine:
    mov rax, 1
    mov rdi, 1
    mov rsi, newLine
    mov rdx, 1
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
