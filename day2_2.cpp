#include <iostream>

constexpr char a[7][7] = { "\0\0\0\0\0\0", "\0\0\0001\0\0", "\0\000234\0", "\00056789", "\0\000ABC\0", "\0\0\000D\0\0" };
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
    freopen("day2.txt", "r", stdin);
    x = 3; y = 1;
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            for (char c : line) {
                int d = r(c), nx = x + dx[d], ny = y + dy[d];
                if (!a[nx][ny]) continue;
                x = nx; y = ny;
            }
            std::cout << a[x][y];
        }
    }
    return 0;
}