#include <iostream>
#include <queue>
#include <tuple>
#include <cstring>
#include <algorithm>
#include <cctype>

char map[200][200];
int n, m, t;

std::queue< std::tuple<int, int, int, int> > Q;
int sx, sy;

constexpr int dx[4] = { 0, 1, 0, -1 }, dy[4] = { 1, 0, -1, 0 };
bool vis[128][200][200];

int main() {
    freopen("day24.txt", "r", stdin);
    while (std::cin >> map[n]) ++n;
    m = std::strlen(map[0]);
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < m; ++j)
            if (map[i][j] == '0') sx = i, sy = j;
            else if (std::isdigit(map[i][j])) ++t;
    Q.emplace(0, sx, sy, 0); vis[0][sx][sy] = true;
    while (!Q.empty()) {
        auto [S, x, y, d] = Q.front(); Q.pop();
        if (S == (1 << t) - 1) { std::cout << d << std::endl; return 0; }
        for (int i = 0; i < 4; ++i) {
            int nx = x + dx[i], ny = y + dy[i];
            if (nx < 0 || ny < 0 || nx >= n || ny >= m || map[nx][ny] == '#') continue;
            int nS = S;
            if (isdigit(map[nx][ny]) && map[nx][ny] != '0') nS |= 1 << (map[nx][ny] - '1');
            if (!vis[nS][nx][ny]) vis[nS][nx][ny] = true, Q.emplace(nS, nx, ny, d + 1);
        }
    }
    return 0;
}