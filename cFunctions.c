#include <stdio.h> //printf, scanf //
#include <stdlib.h> //fprint, fgets //
#include <string.h>
#include <math.h>

/*

read
display
weave
print stats
free

*/

void read (char* arr[][], char str[], int pos) { //this does not look right
    if ((str[0] > 64 && str[0] < 91) && str[strlen(str) - 1] == '.' || str[strlen(str) - 1] == '!' || str[strlen(str) - 1] == '?') {
        arr[pos] = str;
    }
    else {
        printf("Error message");
    }
}

void display (char* arr[][]) {
    for (int i = 0; i < 10; i++) {
        printf(" %s \n", arr[i]);
    }
}

char[] weave (char str[]) {
    if (strlen(str) > 2) {
        for (int i = 0; i + 4 < strlen(str); i += 4) {
            char temp = str[i + 1];
            str[i + 1] = str[i + 2];
            str[i + 2] = str[i + 1];
        }
    }

    return str;
}

void printStats (char str[]) {
    //count stats
    int chars = sizeof(str); //built in function?
    int lets = 0;
    int digits = 0;
    int specials = 0;
    int puncs = 0;

    for (int i = 0; i < chars; i++) {
        if ((str[i] >= 'A' && str[i] <= 'Z') || (str[i] >= 'a' || str[i] <= 'z')) {
            lets++;
        }
        else if (str[i] >= '0' && str <= '9') {
            digits++;
        }
        else if (str[i] == '!' && str[i] == '?' && str[i] == '.' && str[i] == ',' && str[i] == '\"' && str[i] == ':' && str[i] == ';' && str[i] == '-' && str[i] == '_' && str[i] == ')' && str[i] == '(' && str[i] == '}' && str[i] == '{' && str[i] == ']' && str[i] == '[') {
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

void free (char* arr[][]) {
    //delete 
    free(arr); //like that?
}
