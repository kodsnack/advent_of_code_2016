#include <iostream>
#include "pystrlib.hpp"

std::vector<std::string> inst;
int x, y, dir;

constexpr int dx[4] = { 0, 1, 0, -1 }, dy[4] = { 1, 0, -1, 0 };

int main() {
    {
        std::string line;
        std::getline(std::cin, line);
        inst = lib::split(line, ", ");
    }
    for (const std::string &v : inst) {
        if (v[0] == 'L') dir ? --dir : (dir = 3);
        else (dir == 3) ? (dir = 0) : ++dir;
        int k = std::stoi(v.substr(1));
        x += k * dx[dir]; y += k * dy[dir];
    }
    std::cout << std::abs(x) + std::abs(y) << std::endl;
    return 0;
}