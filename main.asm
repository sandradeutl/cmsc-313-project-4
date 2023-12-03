section .data

menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10 ,"enter option letter -> "
menuPromptLen:  equ $- menuPrompt
;idk why the color is completely in string form though

printS:         db "this is s", 10
printSLen       equ $- printS

printR:         db "this is r", 10
printRLen       equ $- printR

printE:         db "this is e", 10
printELen       equ $- printE

printP:         db "this is p", 10
printPLen       equ $- printP

cat:            db "      |\      _,,,---,,_", 10, "ZZZzz /,`.-'`'    -.  ;-;;,_", 10, "     |,4-  ) )-,_. ,\ (  `'-'", 10, "    '---''(_/--'  `-'\_)  sshh, the cat's sleeping. (Felix Lee) ", 10
catLen:         equ $- cat

section .bss

menuAns:        resb 2 ;one character + newLine

section .text

global main

main:
    xor r8, r8
    xor r10, r10 ;this will be the temporary z counter

prompt:
    xor r10, r10
    
    mov rax, 1
    mov rdi, 1
    mov rsi, menuPrompt
    mov rdx, menuPromptLen
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, menuAns
    mov rdx, 2
    syscall

comparing:
    mov r8b, byte[menuAns]

    cmp r8b, 83 ;s
    je printSL
    cmp r8b, 115
    je printSL

    cmp r8b, 82 ;r
    je printRL
    cmp r8b, 114
    je printRL

    cmp r8b, 69 ;e
    je printEL
    cmp r8b, 101
    je printEL

    cmp r8b, 80 ;p
    je printPL
    cmp r8b, 112
    je printPL

    cmp r8b, 81 ;q
    je exit
    cmp r8b, 113
    je exit

    cmp r8b, 90 ;z (counter)
    je incrementCat
    cmp r8b, 122
    je incrementCat

    jmp prompt ;else statemetn

incrementCat:
    inc r10
    cmp r10, 4 ;this only runs with the wrong letter
    je catPrint
    jmp prompt


printSL:
    xor r10, r10
    
    mov rax, 1
    mov rdi, 1
    mov rsi, printS
    mov rdx, printSLen
    syscall

    jmp prompt

printRL:
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, printR
    mov rdx, printRLen
    syscall

    jmp prompt

printEL:
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, printE
    mov rdx, printELen
    syscall

    jmp prompt

printPL:
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, printP
    mov rdx, printPLen
    syscall

    jmp prompt


catPrint:
    mov rax, 1
    mov rdi, 1
    mov rsi, cat
    mov rdx, catLen
    syscall

exit:
    mov rax, 60 ;seg faults, I am looking into this
    xor rdi, rdi
;I annotated the write up for this and drew out some logic ideas I will implement Thursday