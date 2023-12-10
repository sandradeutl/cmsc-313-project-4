FILE  = main
FILE2 = cFunctions
FILE3 =
FILE4 =
FILE5 =
FILE6 =
all: $(FILE)

$(FILE): $(FILE).asm
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	gcc -m64 -o $(FILE) $(FILE).o

two: $(FILE).asm $(FILE2).c
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	gcc -c $(FILE2).c -o $(FILE2).o
	gcc -m64 -o $(FILE) $(FILE2).o $(FILE).o

three: $(FILE).asm $(FILE2).asm $(FILE3).asm
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	gcc -m64 -o $(FILE) $(FILE2).o $(FILE3).o $(FILE).o 

four: $(FILE).asm $(FILE2).asm $(FILE3).asm $(FILE4).asm
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	nasm -f elf64 -l $(FILE4).lst $(FILE4).asm
	gcc -m64 -o $(FILE) $(FILE2).o $(FILE3).o $(FILE4).o $(FILE).o 

five: $(FILE).asm $(FILE2).asm $(FILE3).asm $(FILE4).asm $(FILE5).c
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	nasm -f elf64 -l $(FILE4).lst $(FILE4).asm
	gcc -c	$(FILE5).c -o $(FILE5).o
	gcc -m64 -o $(FILE) $(FILE2).o $(FILE3).o $(FILE4).o $(FILE5).o $(FILE).o -lm 

six: $(FILE).asm $(FILE2).asm $(FILE3).asm $(FILE4).asm $(FILE5).asm $(FILE6).c
	nasm -f elf64 -l $(FILE).lst $(FILE).asm
	nasm -f elf64 -l $(FILE2).lst $(FILE2).asm
	nasm -f elf64 -l $(FILE3).lst $(FILE3).asm
	nasm -f elf64 -l $(FILE4).lst $(FILE4).asm
	nasm -f elf64 -l $(FILE5).lst $(FILE5).asm
	gcc -c  $(FILE6).c -o $(FILE6).o
	gcc -m64 -o $(FILE) $(FILE2).o $(FILE3).o $(FILE4).o $(FILE5).o $(FILE6).o $(FILE).o -lm 

run: $(FILE)
	./$(FILE)

clean: 
	rm *.o  *.lst
