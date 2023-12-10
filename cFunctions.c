#include <stdio.h> //printf, scanf //
#include <stdlib.h> //fprint, fgets //
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdbool.h>
#include <ctype.h>

/*

read
display
weave
print stats
free

*/

//I think this is more similar to another class activity in the past

void read (char** arr, char str[]) { //array had incomplete element type, so apparently in C you need at least one of the [][] to have a number specified
    int loc;
    printf("Please enter a location for the string in the array: ");
    scanf("%d", &loc);
    while (loc > 10 || loc < 1) {
        printf("Please enter a VALID location for the string in the array (1-10): ");
        scanf("%d", &loc);
    }

    loc--; // putting it in array position

    if ((str[0] > 64 && str[0] < 91) && str[strlen(str) - 1] == '.' || str[strlen(str) - 1] == '!' || str[strlen(str) - 1] == '?') {
        free(arr[loc]); //first deleting the string that was there before
        arr[loc] = (char *) malloc(sizeof(char) * strlen(str));

        for (int i = 0; i < strlen(str); i++) {
            arr[loc][i] = str[i];
        }
    }
    else {
        printf("Error message");
    }
}

void display (char** arr) {
    for (int i = 0; i < 10; i++) {
        printf(" %s \n", arr[i]);
    }
}

void weave (char** arr) {

    int loc;
    printf("Please enter a location for the string in the array: ");
    scanf("%d", &loc);
    while (loc > 10 || loc < 1) {
        printf("Please enter a VALID location for the string in the array (1-10): ");
        scanf("%d", &loc);
    }
    
    if (strlen(arr[loc]) > 2) {
        for (int i = 0; i + 4 < strlen(arr[loc]); i += 4) {
            char temp = arr[loc][i + 1];
            arr[loc][i + 1] = arr[loc][i + 2];
            arr[loc][i + 2] = arr[loc][i + 1];
        }
    }
}

void printStats (char** arr) {
    int loc;
    printf("Please enter a location for the string in the array: ");
    scanf("%d", &loc);
    while (loc > 10 || loc < 1) {
        printf("Please enter a VALID location for the string in the array (1-10): ");
        scanf("%d", &loc);
    }


    //count stats
    int chars = strlen(arr[loc]); //built in function?
    int lets = 0;
    int digits = 0;
    int specials = 0;
    int puncs = 0;

    for (int i = 0; i < chars; i++) {
        if ((arr[loc][i] >= 'A' && arr[loc][i] <= 'Z') || (arr[loc][i] >= 'a' || arr[loc][i] <= 'z')) {
            lets++;
        }
        else if (arr[loc][i] >= '0' && arr[loc][i] <= '9') {
            digits++;
        }
        else if (arr[loc][i] == '!' && arr[loc][i] == '?' && arr[loc][i] == '.' && arr[loc][i] == ',' && arr[loc][i] == '\"' && arr[loc][i] == ':' && arr[loc][i] == ';' && arr[loc][i] == '-' && arr[loc][i] == '_' && arr[loc][i] == ')' && arr[loc][i] == '(' && arr[loc][i] == '}' && arr[loc][i] == '{' && arr[loc][i] == ']' && arr[loc][i] == '[') {
            puncs++;
        }
        else {
            specials++;
        }
    }

    printf("There are a total of %n characters in the text. \n", chars);
    printf("There are %n letters. \n", lets);
    printf("There are %n digits. \n", digits);
    printf("There are %n special characters. \n", specials);
    printf("There are %n punctuation characters. \n", puncs);
}

void validateStr(char * messages) {

    int buffer = 256;
    int pos = 0;

    char* cmd = malloc(sizeof(char) * buffer);

    int cha;
    int cont = 1;

    while (cont == 1) {
        cha = getChar(sdtin);
        if (cha == EOF || cha == '\n') {
            cmd[pos] = '\0';
            cont = 0;
        }
        else {
            cmd[pos] = cha;
        }
        pos++;

        if(pos >= buffer) {
            cha = fgetc(stdin);
            buffer += 256;
            cmd = realloc(cmd, buffer);
        }
    } //end while

    //dont use free(cmd); yet!
    return cmd;
} //end validateStr()

void freeMem (char* messages) {
    
    free(messages);
}
