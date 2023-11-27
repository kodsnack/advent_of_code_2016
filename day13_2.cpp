#include <iostream>
#include <tuple>
#include <queue>
#include <set>

std::queue< std::tuple<int, int, int> > Q;
std::set< std::pair<int, int> > V;
int n;

constexpr int dx[4] = { 0, 1, 0, -1 }, dy[4] = { 1, 0, -1, 0 };

bool wall(int x, int y) { return __builtin_popcount(x * x + 3 * x + 2 * x * y + y + y * y + n) & 1; }

int main() {
    std::cin >> n;
    Q.emplace(1, 1, 0); V.emplace(1, 1);
    while (!Q.empty()) {
        auto [x, y, d] = Q.front(); Q.pop();
        if (d >= 50) break;
        for (int k = 0; k < 4; ++k) {
            int nx = x + dx[k], ny = y + dy[k];
            if (nx < 0 || ny < 0 || wall(nx, ny) || V.count(std::make_pair(nx, ny))) continue;
            Q.emplace(nx, ny, d + 1); V.emplace(nx, ny);
        }
    }
    std::cout << V.size() << std::endl;
    return 0;
}