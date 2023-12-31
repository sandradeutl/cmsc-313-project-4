; Sandra Deutl - BZ84214
; Katheryne Lochart- MW24658
; CMSC 313 Project 4

; This is a menu driven program that allows you to manipulate strings based on the provided options


extern read
extern display
extern weave
extern printStats
extern printf
extern freeMem

section .data
msg: db "This is the original message.", 10, 0
msg_len: equ $- msg
pf: db "%s", 10, 0

menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10 ,"enter option letter -> "
menuPromptLen:  equ $- menuPrompt

readPrompt:      db "Please enter a string: ", 10 ;the string input is in assembly and the location input is in c because of convenience on both ends
readPromptLen:   equ $- readPrompt

newMsg: db "Here is your new message:"
inputMsg: db "User input message.", 10, 10, 0 

invalidPrompt:  db "Invalid option, try again!", 10
invalidPromptLen:  equ $- invalidPrompt

cat:            db "      |\      _,,,---,,_", 10, "ZZZzz /,`.-'`'    -.  ;-;;,_", 10, "     |,4-  ) )-,_. ,\ (  `'-'", 10, "    '---''(_/--'  `-'\_)  sshh, the cat's sleeping. (Felix Lee) ", 10
catLen:         equ $- cat

section .bss
menuAns:        resb 2 ;one character + newLine
zCounter:       resb 1 ;z counter
newString:      resb 100 ;temp location for new input string
stringarray:    resq 1

section .text

global main

main:
    mov qword[stringarray], msg
    
    mov rdi, pf
    mov rsi, [stringarray]
    mov rax, 0
    call printf

    mov rdi, menuPrompt
    mov rax, 0
    call printf

    ;xor r8, r8
    ;mov r10b, zCounter
    ;xor r10, r10 ;this will be the temporary z counter
    
readInput:
    mov rdi, msg
    call validateStr
    mov [stringarray], rax

    mov rdi, newMsg
    mov rax, 0
    call printf

    mov rdi, pf
    mov rsi, [stringarray]
    mov rax, 0
    call printf

comparing:
    mov rax, byte[stringarray]

    cmp rax, 83 ;s
    je optionDisplay
    cmp rax, 115
    je optionDisplay

    cmp rax, 82 ;r
    je optionRead
    cmp rax, 114
    je optionRead

    cmp rax, 69 ;e
    je optionEncrypt
    cmp rax, 101
    je optionEncrypt

    cmp rax, 80 ;p
    je optionPrint
    cmp rax, 112
    je optionPrint

    cmp rax, 81 ;q
    je exit
    cmp rax, 113
    je exit

    cmp rax, 90 ;z (counter)
    je incrementCat
    cmp rax, 122
    je incrementCat

    jmp invalid ;else statemetn

incrementCat:
    mov r10b, zCounter
    inc r10
    cmp r10, 4 ;this only runs with the wrong letter
    je catPrint
    jmp invalid


optionDisplay:
    mov r10b, zCounter
    ;xor r10, r10
    
    ;put parameters in place
    mov rdi, [new]
    call display

    jmp prompt

optionRead:
    mov r10b, zCounter
    ;xor r10, r10

    ;asking for string
    mov rax, 1
    mov rdi, 1
    mov rsi, readPrompt
    mov rdx, readPromptLen
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, newString
    mov rdx, 100
    syscall

    ;rax also has the size of the string here??

    ;put parameters in place
    mov rdi, msg_arr
    mov rsi, newString
    call read


    jmp prompt

;need to randomly determine which to call
;need a je statement for whichever c function to call
optionEncrypt:
    mov r10b, zCounter
    ;xor r10, r10

    jmp randChooseE

randChooseE:
    rdrand eax ;generate and store a randomly generated number in eax
    mov ebx, 2
    div ebx
    
    cmp edx, 1 ; if the number is odd
    ja goReverse
    jmp goWeave

goReverse:
   call reverse
    jmp prompt

goWeave:
    mov rdi, msg_arr
    call weave
    jmp prompt

optionPrint:
    mov r10b, zCounter
    ;xor r10, r10

    mov rdi, msg_arr
    call printStats
    jmp prompt

invalid:
    mov r10b, zCounter
    xor r10, r10

    mov rax, 1
    mov rdi, 1
    mov rsi, invalidPrompt
    mov rdx, invalidPromptLen

    jmp prompt


catPrint:
    mov rax, 1
    mov rdi, 1
    mov rsi, cat
    mov rdx, catLen
    syscall

exit:
    exor rsi, rsi
    mov rdi, [stringarray]
    call freeMem
    xor rax, rax
    ret
