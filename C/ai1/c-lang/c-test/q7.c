#include <stdio.h>

int main(){
    int num1 = 0;
    int num2 = 0;
    int temp = 0;

    printf("Enter num1: ");
    scanf("%d", &num1);
    printf("Enter num2: ");
    scanf("%d", &num2);

    if(num1 < num2){
        temp = num1;
        num1 = num2;
        num2 = temp;
    }

    printf("%d / %d = %d\n", num1, num2, num1 / num2);
    printf("%d %% %d = %d\n", num1, num2, num1 % num2);
}