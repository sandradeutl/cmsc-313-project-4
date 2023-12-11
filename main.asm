extern readStr
extern display
extern weave
extern printStats
extern printf
extern validateStr
extern freeMem

section .data
msg: db "This is the original message.", 10, 0
msg_len: equ $- msg
pf: db "%s", 10, 0

menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10, 0
;10 ,"enter option letter -> ", 0
menuPromptLen:  equ $- menuPrompt

readPrompt:      db "Please enter a string: ", 10 ;the string input is in assembly and the location input is in c because of convenience on both ends
readPromptLen:   equ $- readPrompt

invalidPrompt:  db "Invalid option, try again!", 10
invalidPromptLen:  equ $- invalidPrompt

cat:            db "      |\      _,,,---,,_", 10, "ZZZzz /,`.-'`'    -.  ;-;;,_", 10, "     |,4-  ) )-,_. ,\ (  `'-'", 10, "    '---''(_/--'  `-'\_)  sshh, the cat's sleeping.", 10
catLen:         equ $- cat

section .bss
menuAns:        resb 2 ;one character + newLine
newString:      resb 100 ;temp location for new input string
stringarray:    resq 1

section .text

global main

main:
    mov qword[stringarray], msg

    xor r12, r12
    
    ;mov rdi, pf
    ;mov rsi, [stringarray]
    ;mov rax, 0
    ;call printf


     
readInput:
    mov rdi, msg
    call validateStr
    mov [stringarray], rax

    ; mov rdi, newMsg
    ; mov rax, 0
    ; call printf

    ; mov rdi, pf
    ; mov rsi, [stringarray]
    ; mov rax, 0
    ; call printf

prompt:
    mov rdi, menuPrompt
    mov rsi, menuPromptLen
    mov rax, 0
    call printf

    ; mov rax, 1
    ; mov rdi, 1
    ; mov rsi, menuPrompt
    ; mov rdx, menuPromptLen

    mov rax, 0
    mov rdi, 0
    mov rsi, menuAns
    mov rdx, 2
    syscall


comparing:
    mov rax, menuAns

    cmp byte[rax], 83 ;s
    je optionDisplay
    cmp byte[rax], 115
    je optionDisplay

    cmp byte[rax], 82 ;r
    je optionRead
    cmp byte[rax], 114
    je optionRead

    cmp byte[rax], 69 ;e
    je optionEncrypt
    cmp byte[rax], 101
    je optionEncrypt

    cmp byte[rax], 80 ;p
    je optionPrint
    cmp byte[rax], 112
    je optionPrint

    cmp byte[rax], 81 ;q
    je exit
    cmp byte[rax], 113
    je exit

    cmp byte[rax], 90 ;z (counter)
    je incrementCat
    cmp byte[rax], 122
    je incrementCat

    jmp invalid ;else statemetn

incrementCat:

    inc r12
    cmp r12, 4
    je catPrint
    jmp invalidPrint


optionDisplay:

    xor r12, r12
    
    ;put parameters in place
    mov rdi, [stringarray]
    call display

    jmp prompt

optionRead:

    xor r12, r12

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
    mov rdi, stringarray
    mov rsi, newString
    call readStr


    jmp prompt

;need to randomly determine which to call
;need a je statement for whichever c function to call
optionEncrypt:

    xor r12, r12

    jmp randChooseE

randChooseE:
    rdrand eax ;generate and store a randomly generated number in eax
    mov ebx, 2
    div ebx
    
    cmp edx, 1 ; if the number is odd
    ja goReverse
    jmp goWeave

goReverse:
    ;need to figure out how to pass a certain string to

    ;put parameters in place
    
    jmp prompt

goWeave:
    ;put parameters in place
    ;where to ask for location of the string array?
    ;currently i am going to choose to ask for the location in  C because it's easier there
    mov rdi, stringarray
    call weave

    jmp prompt

optionPrint:

    xor r12, r12

    ;put parameters in place
    mov rdi, stringarray
    call printStats

    jmp prompt

invalid:

    xor r12, r12
    jmp invalidPrompt

invalidPrint:

    mov rax, 1
    mov rdi, 1
    mov rsi, invalidPrompt
    mov rdx, invalidPromptLen

    syscall

    jmp prompt


catPrint:
    mov rax, 1
    mov rdi, 1
    mov rsi, cat
    mov rdx, catLen
    syscall

exit:
    xor rsi, rsi
    mov rdi, [stringarray]
    call freeMem
    xor rax, rax
    ret
