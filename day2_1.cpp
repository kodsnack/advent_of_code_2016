#include <iostream>

constexpr int a[3][3] = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 }};
int x, y;
constexpr int dx[4] = { -1, 0, 1, 0 }, dy[4] = { 0, 1, 0, -1 };

inline int r(char c) {
    switch (c) {
        case 'U': return 0;
        case 'R': return 1;
        case 'D': return 2;
        case 'L': return 3;
    }
    return -1;
}

int main() {
    x = 1; y = 1;
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            for (char c : line) {
                int d = r(c), nx = x + dx[d], ny = y + dy[d];
                if (nx < 0 || nx > 2 || ny < 0 || ny > 2) continue;
                x = nx; y = ny;
            }
            std::cout << a[x][y];
        }
    }
    return 0;
}