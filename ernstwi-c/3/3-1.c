#include <stdio.h>

int main(void) {
    int possible = 0;
    int a, b, c;

    while (scanf("%d%d%d", &a, &b, &c) != EOF) {
        if (a+b>c && a+c>b && b+c>a)
            possible++;
    }

    printf("%d\n", possible);
}
