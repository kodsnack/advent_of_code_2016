#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    int letters[26];
    char *top_letters = malloc(6 * sizeof(char));
    top_letters[5] = '\0';
    int sector;
    int sector_sum = 0;
    char *checksum = malloc(6 * sizeof(char));
    checksum[5] = '\0';

    while (!feof(stdin)) {
        memset(letters, 0, 26 * sizeof(int));

        // scan name
        char c;
        while ((c = getchar()) == '-' || (c>96 && c<123)) {
            if (c != '-')
                letters[c-97]++;
        }

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

        // check checksum
        if (strcmp(top_letters, checksum) == 0)
            sector_sum += sector;
    }
    printf("%d\n", sector_sum);
}
