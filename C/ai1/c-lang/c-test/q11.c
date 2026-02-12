#include <stdio.h>

int main(){
    int count[9] = {0,};
    int input = 0;
    int most = 0;

    printf("Enter 20 numbers: ");
    
    for(int i = 0; i < 20; i++){
        scanf("%d", &input);
        if(input < 0 || input > 9){
            printf("Invalid number.\n");
            return 0;
        }
        count[input]++;
    }

    for(int i = 0; i < sizeof(count)/sizeof(int); i++){
        if(count[most] < count[i]) most = i;
    }

    printf("Frequency: %d\nNumber: %d\n", count[most], most);
}