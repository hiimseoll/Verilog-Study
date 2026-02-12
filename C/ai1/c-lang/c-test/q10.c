#include <stdio.h>

int main(){
    double nums[] = {98.56, 78.62, 89.32, 95.29};
    double sum = 0;

    for(int i = 0; i < sizeof(nums)/sizeof(int); i++){
        sum += nums[i];
    }

    printf("sum  = %.2lf\naverage = %.2lf\n", sum, sum / (sizeof(nums)/sizeof(int)));
}