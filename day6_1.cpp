#include <iostream>
#include <cstring>

std::string p[1000];
int len, n, bb[128];

int main() {
    freopen("day6.txt", "r", stdin);
    while (std::getline(std::cin, p[n])) ++n;
    len = p[0].size();
    for (int i = 0; i < len; ++i) {
        memset(bb, 0, sizeof(bb));
        for (int j = 0; j < n; ++j) ++bb[p[j][i]];
        int u = 0;
        for (int j = 1; j < 128; ++j) if (bb[j] > bb[u]) u = j;
        putchar(u);
    }
    return 0;
}