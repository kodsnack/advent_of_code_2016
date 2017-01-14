#include <stdio.h>

int main(void) {
    int possible = 0;
    int t[3][3];

    while (!feof(stdin)) {
        for (int i = 0; i < 3; i++) {
            scanf("%d%d%d", &t[i][0], &t[i][1], &t[i][2]);
        }
        for (int i = 0; i < 3; i++) {
            if (t[0][i]+t[1][i]>t[2][i] &&
                t[0][i]+t[2][i]>t[1][i] && 
                t[1][i]+t[2][i]>t[0][i])
                possible++;
        }
    }

    printf("%d\n", possible);
}
