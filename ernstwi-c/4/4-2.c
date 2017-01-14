#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXNAME 100

int wrap(int val, int min, int max) {
    int span = max - min + 1;
    return min + ((val - min) % span);
}

int main(void) {
    char *name = malloc(MAXNAME * sizeof(char));
    int name_offs;
    int letters[26];
    char *top_letters = malloc(6 * sizeof(char));
    top_letters[5] = '\0';
    int sector;
    char *checksum = malloc(6 * sizeof(char));
    checksum[5] = '\0';

    while (!feof(stdin)) {
        memset(letters, 0, 26 * sizeof(int));
        name_offs = 0;

        // scan name
        char c;
        while ((c = getchar()) == '-' || (c>96 && c<123)) {
            name[name_offs] = c;
            name_offs++;
            if (c != '-')
                letters[c-97]++;
        }
        name[name_offs] = '\0';

        // scan sector ID
        ungetc(c, stdin);
        scanf("%d", &sector);
        scanf("[%5s]\n", checksum);

        // select top letters
        for (int i = 0; i < 5; i++) {
            int top = 0;
            for (int j = 1; j < 26; j++) {
                if (letters[j] > letters[top]) {
                    top = j;
                }
            }
            letters[top] = -1;
            top_letters[i] = top+97;
        }

        // check checksum and decrypt name
        if (strcmp(top_letters, checksum) == 0) {
            for(int i = 0; i < name_offs; i++) {
                if (name[i] == '-') {
                    name[i] = ' ';
                } else {
                    name[i] = wrap(name[i] + sector, 97, 122);
                }
            }
            printf("%d: %s\n", sector, name);
        }
    }
}
