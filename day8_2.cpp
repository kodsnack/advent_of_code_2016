#include <iostream>
#include "pystrlib.hpp"

int w[10][60], n = 6, m = 50, temp[60], ans;

inline void lit(int x, int y) {
    for (int i = 1; i <= y; ++i)
        for (int j = 1; j <= x; ++j)
            w[i][j] = 1;
}

inline void shr(int x, int y) {
    for (int i = 1; i <= m; ++i) temp[i] = w[x][i];
    for (int i = 1; i <= m; ++i) w[x][(i + y - 1) % m + 1] = temp[i];
}

inline void shc(int x, int y) {
    for (int i = 1; i <= n; ++i) temp[i] = w[i][x];
    for (int i = 1; i <= n; ++i) w[(i + y - 1) % n + 1][x] = temp[i];
}

int main() {
    freopen("day8.txt", "r", stdin);
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::string> v = lib::split(line, " ");
            if (v[0] == "rect") {
                auto [a, _, b] = lib::partition(v[1], "x");
                lit(std::stoi(a), std::stoi(b));
            } else if (v[1] == "row") {
                auto [_, __, a] = lib::partition(v[2], "=");
                shr(std::stoi(a) + 1, std::stoi(v[4]));
            } else {
                auto [_, __, a] = lib::partition(v[2], "=");
                shc(std::stoi(a) + 1, std::stoi(v[4]));
            }
        }
    }
    for (int i = 1; i <= n; ++i) {
        for (int j = 1; j <= m; ++j)
            std::cout << (w[i][j] ? '#' : '.');
        std::cout << std::endl;
    }
    return 0;
}