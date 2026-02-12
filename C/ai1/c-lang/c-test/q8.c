#include <stdio.h>

int main(){
    for(int i = 0; i < 5; i++){
        for(int n = 5; n > i; n--){
            printf("%d", n);
        }
        printf("\n");
    }
}