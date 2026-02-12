#include <stdio.h>

int main(){
    int input = 0;
    int count = 0;
    int count2 = 0;

    while(1){
        printf("2이상의 숫자를 입력하세요(종료:999)> ");
        scanf("%d", &input);

        switch(input){
            case 999:
            return 0;
            
            default:
            break;
        }

        for(int i = 2; i <= input; i++){
            for(int n = 1; n <= i; n++){
                if(i % n == 0) count++;
            }
            if(count == 2){
                printf("%2d ", i);
                if(++count2 % 5 == 0) printf("\n");
            }
            count = 0;
        }
    }
}