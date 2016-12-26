#include <stdio.h>

int pos;
char c;

void move(char dir) {
    switch (dir) {
        case 'U':
            if (pos < 4)
                break;
            pos -= 3;
            break;
        case 'R':
            if (pos == 3 || pos == 6 || pos == 9)
                break;
            pos++;
            break;
        case 'D':
            if (pos > 6)
                break;
            pos += 3;
            break;
        case 'L':
            if (pos == 1 || pos == 4 || pos == 7)
                break;
            pos--;
            break;
    }
}

int main(void) { 
    pos = 5;

    while (1) {
        c = getchar();

        if (c != '\n' && c != EOF) {
            move(c);
        } else {
            printf("%d", pos);
            if (c == EOF) {
                printf("\n");
                break;
            }
        }
    }

    return 0;
}
