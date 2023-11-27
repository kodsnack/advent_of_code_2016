#include <iostream>
#include "pystrlib.hpp"

std::string data, decoded;

int main() {
    freopen("day9.txt", "r", stdin);
    std::getline(std::cin, data);
    int len = data.size();
    for (int i = 0; i < len; ++i)
        if (data[i] == '(') {
            int j = i + 1;
            while (data[j] != ')') ++j;
            auto [c, _, r] = lib::partition(data.substr(i + 1, j - i - 1), "x");
            int cv = std::stoi(c), rv = std::stoi(r);
            std::string pd = data.substr(j + 1, cv);
            for (int i = 0; i < rv; ++i) decoded += pd;
            i = j + cv;
        } else decoded += data[i];
    std::cout << decoded.size() << std::endl;
    return 0;
}