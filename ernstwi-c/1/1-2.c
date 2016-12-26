#include <stdio.h>
#include <stdlib.h>

enum dir { N, E, S, W };
struct location {
    int x;
    int y;
    struct location *next;
};

struct location *head;

void visit(int x, int y) {
    printf("visit(%d, %d)\n", x, y);
    struct location *current = head;
    while (current != NULL) {
        if (current->x == x && current->y == y) {
            printf("%d\n", abs(x) + abs(y));
            exit(0);
        }
        current = current->next;
    }

    struct location *new = malloc(sizeof(struct location));
    new->x = x;
    new->y = y;
    new->next = head;
    head = new;
}

int main(void) {
    enum dir facing;
    char turn;
    int walk, x, y;
    x = 0; y = 0; facing = N;

    head = malloc(sizeof(struct location));
    head->x = x;
    head->y = y;
    head->next = NULL;

    while (scanf("%c%d, ", &turn, &walk) != EOF) {
        printf("\n");
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
                for (int i = 1; i <= walk; i++) {
                    visit(x, y+i);
                }
                y += walk;
                break;
            case E:
                for (int i = 1; i <= walk; i++) {
                    visit(x+i, y);
                }
                x += walk;
                break;
            case S:
                for (int i = 1; i <= walk; i++) {
                    visit(x, y-i);
                }
                y -= walk;
                break;
            case W:
                for (int i = 1; i <= walk; i++) {
                    visit(x-i, y);
                }
                x -= walk;
                break;
        }
    }
    return 0;
}
