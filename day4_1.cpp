#include <iostream>
#include <algorithm>
#include <cstring>
#include "pystrlib.hpp"

char p[27];
int bb[128], ans;

int main() {
    freopen("day4.txt", "r", stdin);
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::strcpy(p, "abcdefghijklmnopqrstuvwxyz");
            std::memset(bb, 0, sizeof(bb));
            auto [f, _, t] = lib::rpartition(line, "-");
            auto [id, __, c] = lib::partition(t, "[");
            c.pop_back();
            for (char ch : f) ++bb[ch];
            std::stable_sort(p, p + 26, [] (char a, char b) { return bb[a] > bb[b]; });
            p[5] = 0; !strcmp(p, c.c_str()) && (ans += std::stoi(id));
        }
    }
    std::cout << ans << std::endl;
    return 0;
}