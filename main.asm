extern read
extern display
extern weave
extern printStats
extern free
section .data

; how do we choose what string to work on? - prompt user

msg: db "This is the origional string." ; to be read in character by character
menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10 ,"enter option letter -> "
menuPromptLen:  equ $- menuPrompt

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

main:
    push rbp ;maybe?
    xor r8, r8
    xor r10, r10 ;this will be the temporary z counter

; dyn alloc everything
; means you have to dyn all in assemlby and also C
; heavy at first but at least you know everything is dynamically allocated

allocateStrMem:
    ; create dyn memory
    mov edi, 40 ;determine size later for now
    extern malloc
    call malloc

    mov DWORD[rax], 7 ;fix this constant later
    mov eax, DWORD[rax]
    ret

    ; array that holds 10 addresses

    ; need to dyn allocat 10 blocks

    ; each time dyn alloc a block, it will be empty

    ; then have to copy the characters char by char into the block

    ; can do manually

    ; then has to point to the string


 ; overcomplicated ----------------------------------------------------   
    ;mov rbx, msg_arr

    mov edi, 12 ;need to figue out syscall for this
    mov eax, 12
    syscall

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
    je optionDisplay
    cmp r8b, 115
    je optionDisplay

    cmp r8b, 82 ;r
    je optionRead
    cmp r8b, 114
    je optionRead

    cmp r8b, 69 ;e
    je optionEncrypt
    cmp r8b, 101
    je optionEncrypt

    cmp r8b, 80 ;p
    je optionPrint
    cmp r8b, 112
    je optionPrint

    cmp r8b, 81 ;q
    je exit
    cmp r8b, 113
    je exit

    cmp r8b, 90 ;z (counter)
    je incrementCat
    cmp r8b, 122
    je incrementCat

    jmp prompt ;else statement

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

optionRead:
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
optionEncrypt:
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
    cmp eax, 64 ;do we need to compare twice? because if it doesn't jump to goReverse, the next line is already the "else"
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
