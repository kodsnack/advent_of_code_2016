#include <iostream>
#include "pystrlib.hpp"
#include <queue>
#include <tuple>

int used[33][30], avail[33][30], size[33][30];
int n = 33, m = 30;

bool vis[33][30][33][30];
int ex, ey;
bool big[33][30];

std::queue< std::tuple<int, int, int, int, int> > Q;

constexpr int dx[4] = {0, 1, 0, -1}, dy[4] = {1, 0, -1, 0};

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
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < m; ++j)
            if (!used[i][j]) { ex = i; ey = j; goto found_empty; }
    found_empty:
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < m; ++j)
            if (used[i][j] > avail[ex][ey]) big[i][j] = true;
    vis[ex][ey][n - 1][0] = true;
    Q.emplace(ex, ey, n - 1, 0, 0);
    while (!Q.empty()) {
        auto [ex, ey, dx, dy, d] = Q.front(); Q.pop();
        if (!dx && !dy) { std::cout << d << std::endl; return 0; }
        for (int i = 0; i < 4; ++i) {
            int nx = ex + ::dx[i], ny = ey + ::dy[i];
            if (nx < 0 || nx >= n || ny < 0 || ny >= m || big[nx][ny]) continue;
            if (nx == dx && ny == dy) { if (!vis[nx][ny][ex][ey]) vis[nx][ny][ex][ey] = true, Q.emplace(nx, ny, ex, ey, d + 1); }
            else if (!vis[nx][ny][dx][dy]) vis[nx][ny][dx][dy] = true, Q.emplace(nx, ny, dx, dy, d + 1);
        }
    }
    return 0;
}