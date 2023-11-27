#include <iostream>
#include "pystrlib.hpp"

std::vector<std::string> inst;
int x = 500, y = 500, dir;

constexpr int dx[4] = { 0, 1, 0, -1 }, dy[4] = { 1, 0, -1, 0 };
bool vis[1000][1000];

int main() {
    {
        std::string line;
        std::getline(std::cin, line);
        inst = lib::split(line, ", ");
    }
    vis[x][y] = 1;
    for (const std::string &v : inst) {
        if (v[0] == 'L') dir ? --dir : (dir = 3);
        else (dir == 3) ? (dir = 0) : ++dir;
        int k = std::stoi(v.substr(1));
        for (int i = 0; i < k; ++i) {
            x += dx[dir]; y += dy[dir];
            if (vis[x][y]) goto l;
            vis[x][y] = 1;
        }
    }
    l: std::cout << std::abs(x - 500) + std::abs(y - 500) << std::endl;
    return 0;
}