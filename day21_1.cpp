#include <iostream>
#include <algorithm>
#include "pystrlib.hpp"

std::string pass = "abcdefgh";

inline void swap(int a, int b) { std::swap(pass[a], pass[b]); }
inline int index(char c) { for (unsigned i = 0; i < pass.size(); ++i) if (pass[i] == c) return i; return -1; }
inline void rotate(int r) {r %= (int) pass.size(); (r < 0) && (r += pass.size()); pass = pass.substr(pass.size() - r, r) + pass.substr(0, pass.size() - r); }
inline void reverse(int a, int b) { std::reverse(pass.begin() + a, pass.begin() + b + 1); }
inline void move(int a, int b) { char c = pass[a]; pass.erase(pass.begin() + a); pass.insert(pass.begin() + b, c); }

int main() {
    freopen("day21.txt", "r", stdin);
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::string> v = lib::split(line, " ");
            if (v[0] == "swap") {
                if (v[1] == "position") swap(std::stoi(v[2]), std::stoi(v[5]));
                else if (v[1] == "letter") swap(index(v[2][0]), index(v[5][0]));
            } else if (v[0] == "rotate") {
                if (v[1] == "right") rotate(std::stoi(v[2]));
                else if (v[1] == "left") rotate(-std::stoi(v[2]));
                else if (v[1] == "based") { int i = index(v[6][0]); rotate(1 + i + (i > 3)); }
            } else if (v[0] == "reverse") reverse(std::stoi(v[2]), std::stoi(v[4]));
            else if (v[0] == "move") move(std::stoi(v[2]), std::stoi(v[5]));
        }
    }
    std::cout << pass << std::endl;
    return 0;
}