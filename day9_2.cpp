#include <iostream>
#include "pystrlib.hpp"

std::string data;

long long get_size(int i, int j) {
    long long size = 0;
    for (; i < j; ++i)
        if (data[i] == '(') {
            int r = i + 1;
            while (data[r] != ')') ++r;
            auto [d, _, c] = lib::partition(data.substr(i + 1, r - i - 1), "x");
            int dv = std::stoi(d), cv = std::stoi(c);
            size += get_size(r + 1, r + 1 + dv) * cv;
            i = r + dv;
        } else ++size;
    return size;
}

int main() {
    freopen("day9.txt", "r", stdin);
    std::getline(std::cin, data);
    std::cout << get_size(0, data.size()) << std::endl;
    return 0;
}