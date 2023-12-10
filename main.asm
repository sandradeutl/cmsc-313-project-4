extern read
extern display
extern weave
extern printStats
extern printf
extern freeMem

;---------------------------------------------------------------------------------------

section .data
msg: db "This is the original message.", 10, 0
msg_len: equ $- msg
pf: db "%s", 10, 0

menuPrompt:     db "Encryption menu options:", 10 ,"s - show current messages", 10 ,"r - read new message", 10 ,"e - transform", 10 ,"p - print stats", 10 ,"q - quit program", 10 ,"enter option letter -> "
menuPromptLen:  equ $- menuPrompt
;idk why the color is completely in string form though

readPrompt:      db "Please enter a string: ", 10 ;the string input is in assembly and the location input is in c because of convenience on both ends
readPromptLen:   equ $- readPrompt

inputMsg: db "User input message.", 10, 10, 0 

invalidPrompt:  db "Invalid option, try again!", 10
invalidPromptLen:  equ $- invalidPrompt

cat:            db "      |\      _,,,---,,_", 10, "ZZZzz /,`.-'`'    -.  ;-;;,_", 10, "     |,4-  ) )-,_. ,\ (  `'-'", 10, "    '---''(_/--'  `-'\_)  sshh, the cat's sleeping. (Felix Lee) ", 10
catLen:         equ $- cat

;---------------------------------------------------------------------------------------

section .bss
menuAns:        resb 2 ;one character + newLine
zCounter:       resb 1 ;z counter
newString:      resb 100 ;temp location for new input string
stringarray:    resq 1

;---------------------------------------------------------------------------------------

section .text

global main

main:
    xor r8, r8
    mov r10b, zCounter
    xor r10, r10 ;this will be the temporary z counter

    mov qword[stringarray], msg

    mov rdi, readPrompt
    mov rsi, [stringarray]
    mov rax, 0
    call printf
    
readInput:

    mov rdi, msg
    call validateStr
    mov [stringarray], rax

    mov rdi, inputMsg
    mov rax, 0
    call printf

    mov rdi, pfmov rsi, [stringarray]
    mov rax, 0
    call printf

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

    jmp invalid ;else statemetn

incrementCat:
    mov r10b, zCounter
    inc r10
    cmp r10, 4 ;this only runs with the wrong letter
    je catPrint
    jmp invalid


optionDisplay:
    mov r10b, zCounter
    xor r10, r10
    
    ;put parameters in place
    mov rdi, msg_arr
    call display

    jmp prompt

optionRead:
    mov r10b, zCounter
    xor r10, r10

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
    xor r10, r10

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
    mov rdi, msg_arr
    call weave

    jmp prompt

optionPrint:
    mov r10b, zCounter
    xor r10, r10

    ;put parameters in place
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

    syscall

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
