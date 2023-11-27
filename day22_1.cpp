#include <iostream>
#include "pystrlib.hpp"

int used[33][30], avail[33][30], size[33][30];
int n = 33, m = 30;

int main() {
    freopen("day22.txt", "r", stdin);
    {
        std::string line;
        std::getline(std::cin, line); std::getline(std::cin, line);
        while (std::getline(std::cin, line)) {
            std::vector<std::string> vec = lib::split(line, " ");
            vec.erase(std::remove(vec.begin(), vec.end(), ""), vec.end());
            std::vector<std::string> vec2 = lib::split(vec[0], "-");
            int i = std::stoi(vec2[1].substr(1)), j = std::stoi(vec2[2].substr(1));
            size[i][j] = std::stoi(vec[1]);
            used[i][j] = std::stoi(vec[2]);
            avail[i][j] = std::stoi(vec[3]);
        }
    }
    int ans = 0;
    for (int i1 = 0; i1 < n; ++i1)
        for (int j1 = 0; j1 < m; ++j1)
            for (int i2 = 0; i2 < n; ++i2)
                for (int j2 = 0; j2 < m; ++j2)
                    ans += ((i1 != j1) || (i2 != j2)) && used[i1][j1] && (used[i1][j1] <= avail[i2][j2]);
    std::cout << ans << std::endl;
    return 0;
}