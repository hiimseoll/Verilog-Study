#include <stdio.h>

void shift_alpha(char *);

int main(void){
	char alpha[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";   

	shift_alpha(alpha);
	 
	return 0;
}

void shift_alpha(char *alpha){
    char saved;

    for(int i = 0; i <= 26; i++){
        saved = alpha[0];
        for(int n = 0; n < 26; n++){
            printf("%c", alpha[n]);
            alpha[n] = alpha[n + 1];
        }
        printf("\n");
        alpha[25] = saved;
    }
}

