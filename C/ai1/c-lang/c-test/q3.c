#include <stdio.h>

int main(){
    const double PI = 3.14;
    
    double area = 0;
    double perimeter = 0;
    double radius = 7.58;

    area = radius * radius * PI;
    perimeter = 2 * PI * radius;

    printf("area: %lf\nperimeter: %lf", area, perimeter);
}