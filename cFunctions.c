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

void printStats (char* arr[][]) {
    //count stats
}

void free (char* arr[][]) {
    //delete 
    free(arr); //like that?
}
