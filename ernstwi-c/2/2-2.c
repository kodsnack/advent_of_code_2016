#include <stdio.h>

char pos;
char c;

void move(char dir) {
    switch (dir) {
        case 'U':
            switch (pos) {
                case '1':
                case '2':
                case '4':
                case '5':
                case '9':
                    break;
                case '6':
                case '7':
                case '8':
                    pos -= 4;
                    break;
                case 'A':
                case 'B':
                case 'C':
                    pos -= 11;
                    break;
                case '3':
                case 'D':
                    pos -= 2;
                    break;
            }
            break;
        case 'R':
            switch (pos) {
                case '1':
                case '4':
                case '9':
                case 'C':
                case 'D':
                    break;
                default:
                    pos++;
                    break;
            }
            break;
        case 'D':
            switch (pos) {
                case '5':
                case '9':
                case 'A':
                case 'C':
                case 'D':
                    break;
                case '2':
                case '3':
                case '4':
                    pos += 4;
                    break;
                case '6':
                case '7':
                case '8':
                    pos += 11;
                    break;
                case '1':
                case 'B':
                    pos += 2;
                    break;
            }
            break;
        case 'L':
            switch (pos) {
                case '1':
                case '2':
                case '5':
                case 'A':
                case 'D':
                    break;
                default:
                    pos--;
                    break;
            }
            break;
    }
}

int main(void) { 
    pos = '5';

    while (1) {
        c = getchar();

        if (c != '\n' && c != EOF) {
            move(c);
            // printf("%c\n", pos);
        } else {
            printf("%c", pos);
            if (c == EOF) {
                printf("\n");
                break;
            }
        }
    }

    return 0;
}
