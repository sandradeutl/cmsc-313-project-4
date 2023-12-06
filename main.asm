extern read
extern display
extern weave
extern printStats
extern free
section .data

msg1: db "This is the original message.", 0
msg2: db "This is the original message.", 0
msg3: db "This is the original message.", 0
msg4: db "This is the original message.", 0
msg5: db "This is the original message.", 0
msg6: db "This is the original message.", 0
msg7: db "This is the original message.", 0
msg8: db "This is the original message.", 0
msg9: db "This is the original message.", 0
msg10: db "This is the original message.", 0

msg_arr: dq msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8, msg9, msg10

menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10 ,"enter option letter -> "
menuPromptLen:  equ $- menuPrompt
;idk why the color is completely in string form though
; need to add the "Invalid option, try again!" part

invalidPrompt:  db "Invalid option, try again!", 10
invalidPromptLen:  equ $- invalidPrompt

cat:            db "      |\      _,,,---,,_", 10, "ZZZzz /,`.-'`'    -.  ;-;;,_", 10, "     |,4-  ) )-,_. ,\ (  `'-'", 10, "    '---''(_/--'  `-'\_)  sshh, the cat's sleeping. (Felix Lee) ", 10
catLen:         equ $- cat

section .bss

menuAns:        resb 2 ;one character + newLine

zCounter:       resb 2 ;z counter

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
    mov r10, zCounter
    xor r10, r10 ;this will be the temporary z counter

;allocate dynamic memory for string
allocateStrMem:
    mov rbx, msg_arr

    mov edi, 12 ;need to figue out syscall for this
    mov eax, 12
    syscall

    ; error checking for this?

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

    jmp prompt ;else statemetn

incrementCat:
    mov r10, zCounter
    inc r10
    cmp r10, 4 ;this only runs with the wrong letter
    je catPrint
    jmp prompt


optionDisplay:
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

randChooseE:
    rdrand eax ;generate and store a randomly generated number in eax

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

optionPrint:
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
