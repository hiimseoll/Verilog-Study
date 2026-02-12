#include <stdio.h>

int main(){
    for(int i = 0; i < 8; i++){
        for(int n = 7; n >= 0; n--){
            if(n <= i) printf("%d", n);
            else printf(" ");
            
        }
        for(int n = 1; n <= i; n++){
            printf("%d", n);
        }
        printf("\n");
    }
}