#include <iostream>
#include "pystrlib.hpp"
#include <cstdlib>
#include <cassert>

std::vector<int> a[500];

int t1[500], t2[500], stk[500], h, indgr[500];

int mbot;

int main() {
    freopen("day10.txt", "r", stdin);
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::string> v = lib::split(line, " ");
            if (line[0] == 'v')
                a[std::stoi(v[5])].push_back(std::stoi(v[1]));
            else {
                int p = std::stoi(v[1]);
                if (p > mbot) mbot = p;
                t1[p] = (v[5] == "bot" ? 0 : 250) + std::stoi(v[6]);
                t2[p] = (v[10] == "bot" ? 0 : 250) + std::stoi(v[11]);
                if (t1[p] < 250) ++indgr[t1[p]];
                if (t2[p] < 250) ++indgr[t2[p]];
            }
        }
    }
    for (int i = 0; i < mbot; ++i)
        if (!indgr[i]) stk[++h] = i;
    while (h) {
        int u = stk[h--];
        if (a[u][0] == 17 && a[u][1] == 61 || a[u][0] == 61 && a[u][1] == 17) {
            std::cout << u << std::endl;
            return 0;
        }
        a[t1[u]].push_back(std::min(a[u][0], a[u][1]));
        a[t2[u]].push_back(std::max(a[u][0], a[u][1]));
        if (t1[u] < 250 && !--indgr[t1[u]]) stk[++h] = t1[u];
        if (t2[u] < 250 && !--indgr[t2[u]]) stk[++h] = t2[u];
    }
    return 0;
}