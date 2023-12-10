section .data

numPrompt:      db "Enter a number between 2 and the total number of characters in the string: ", 0
numPromptLen:   equ $- numPrompt

resultStr:      db "Unedited String: ", 0
resultStrLen:   equ $- resultStr

calcStr:        db "Edited String: ", 0
calcStrLen:     equ $- calcStr

newLine:        db 10

section .bss

string:         resb 100
num:            resb 3

section .text

global main

main:
    xor r8b, r8b
    xor r9, r9
    xor r12, r12
    xor r13, r13        ;just to make sure registers are null

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
    dec r9b             ;this makes it print "correctly" - but it doesn't for the last one - fix that


printUnedited:
    mov rax, 1
    mov rdi, 1
    mov rsi, resultStr
    mov rdx, resultStrLen
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, string
    mov rdx, 64
    syscall

printEdited:
    mov rax, 1
    mov rdi, 1
    mov rsi, calcStr 
    mov rdx, calcStrLen
    syscall

    mov r8b, r9b
    mov r13, string
    add r13, r9         ;i wanted to do r9b but it won't let me

printChar1:
    mov rax, 1
    mov rdi, 1
    mov rsi, r13
    mov rdx, 1
    syscall

moveThrough1:
    dec r13
    dec r8b
    cmp r8b, 0          ;1 & not 0, bc it'll print char one more time after jumping
    jge printChar1      ;if no jump, move to end
    add r13, r12
    add r8b, r12b       ;r12b bc it's a byte
    cmp r8b, r9b        ;comparing first in case the entire string is reversed - because if the size of the string is input, entire string is reversed as one
    je printNewLine


printChar2:
    mov rax, 1
    mov rdi, 1
    mov rsi, r13
    mov rdx, 1          ;prints only one byte aka one character
    syscall

moveThrough2:
    dec r13
    dec r8b
    cmp r8b, r9b
    jg printChar2

printNewLine:
    mov rax, 1
    mov rdi, 1
    mov rsi, newLine
    mov rdx, 1
    syscall

exit:
    mov rax, 60
    xor rdi, rdi
