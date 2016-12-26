#include <stdio.h>
#include <stdlib.h>

enum dir { N, E, S, W };

int main(void) {
    enum dir facing;
    char turn;
    int walk, x, y;
    x = 0; y = 0; facing = N;

    while (scanf("%c%d, ", &turn, &walk) != EOF) {
        switch (turn) {
            case 'R':
                if (facing == W) {
                    facing = N;
                } else {
                    facing++;
                }
                break;
            case 'L':
                if (facing == N) {
                    facing = W;
                } else {
                    facing--;
                }
                break;
        }
        switch (facing) {
            case N:
                y += walk;
                break;
            case E:
                x += walk;
                break;
            case S:
                y -= walk;
                break;
            case W:
                x -= walk;
                break;
        }
    }
    printf("%d\n", abs(x) + abs(y));
    return 0;
}
