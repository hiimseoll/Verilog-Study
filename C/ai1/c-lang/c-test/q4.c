#include <stdio.h>

int main(){

    int apt[] = {18, 25, 32, 44, 52};

    const double ratio = 3.305785;

    for(int i = 0; i < sizeof(apt)/sizeof(int); i++){
        printf("%dp = %.2lfm2\n", apt[i], apt[i] * ratio);
    }
}