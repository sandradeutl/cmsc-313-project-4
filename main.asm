section .data

; how do we choose what string to work on?

msg1: db "This is the origional message.", 0
msg2: db "This is the origional message.", 0
msg3: db "This is the origional message.", 0
msg4: db "This is the origional message.", 0
msg5: db "This is the origional message.", 0
msg6: db "This is the origional message.", 0
msg7: db "This is the origional message.", 0
msg8: db "This is the origional message.", 0
msg9: db "This is the origional message.", 0
msg10: db "This is the origional message.", 0

msg_arr: dq msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8, msg9, msg10

menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10 ,"enter option letter -> "
menuPromptLen:  equ $- menuPrompt
;idk why the color is completely in string form though
; need to add the "Invalid option, try again!" part

printS:         db "this is s", 10
printSLen       equ $- printS

printR:         db "this is r", 10
printRLen       equ $- printR

printE:         db "this is e", 10 ;need to figure out the string storage/passing situation here
printELen       equ $- printE

printP:         db "this is p", 10
printPLen       equ $- printP

cat:            db "      |\      _,,,---,,_", 10, "ZZZzz /,`.-'`'    -.  ;-;;,_", 10, "     |,4-  ) )-,_. ,\ (  `'-'", 10, "    '---''(_/--'  `-'\_)  sshh, the cat's sleeping. (Felix Lee) ", 10
catLen:         equ $- cat

section .bss

menuAns:        resb 2 ;one character + newLine

section .text

global main

;external c functions
extern read
extern display
extern weave
extern printStats
extern free

main:
    xor r8, r8
    xor r10, r10 ;this will be the temporary z counter

;allocate dynamic memory for string

; initial strings aren't dyn alloc, y
;ou only dyn allo when user wants to read a message, would do dyn mem alloc in C
; disadvantage, in array, some are dyna lloc and some are not, need to keep track 
;of what's dyn alloc and what's not

;dyn alloc everything
;means you have to dyn all in assemlby and also C
; heavy at first but at least you know everything is dynamically allocated


allocateStrMem:
    mov rbx, msg_arr

    mov edi, 12 ;need to figue out syscall for this
    mov eax, 12
    syscall

    ; error checking for this?
    ; can use standard C functions, malloc, need to figure out that setup --------------- CHECK
    ; initialize string once
    ; creat dyn mem
    ; array that can hold 10 addresses o
    ; need to dyn allocat 10 blocks
    ; each time dyn alloc a block, it will be empty
    ; then have to copy the characters char by char into the block
    ; can do manually
    ; then has to point to the string
    ; 


    ; cmp rax, -1
    ; je failed_alloc

    mov [msg_arr], rax
    add rax, 24

    lea rsi, [msg1]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg2]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg3]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg4]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg5]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg6]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg1]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg7]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg8]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg9]
    mov [rax], rsi
    add rax, 8

    lea rsi, [msg10]
    mov [rax], rsi
    
;handle allocation failure?

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
    call display
    syscall

    jmp prompt

printRL:
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, printR
    mov rdx, printRLen
    call read
    syscall

    jmp prompt

;need to randomly determine which to call
;need a je statement for whichever c function to call
printEL:
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, printE
    mov rdx, printELen
    syscall

    jmp randChooseE

;not complete yet
randChooseE:
    rdrand eax ;generate and store a randomly generated number in eax
    ;even or odd, use div instruction, mod will be in the rdx register

    cmp eax, 64 ;need to figure out a different number for this
    ja goReverse
    cmp eax, 64
    jbe goWeave

    jmp prompt

goReverse:
    ;need to figure out how to pass a certain string to
    
    jmp prompt

goWeave:
    call weave

    jmp prompt

printPL:
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, printP
    mov rdx, printPLen
    call printStats
    syscall

    jmp prompt

catPrint:
    mov rax, 1
    mov rdi, 1
    mov rsi, cat
    mov rdx, catLen
    syscall

exit:
    mov rax, 60 ;seg faults
    xor rdi, rdi
    syscall
