#include <iostream>

int v[40][105], n, ans;

int main() {
    {
        std::string line;
        std::cin >> line;
        n = line.size();
        for (int i = 0; i < n; ++i) ans += (v[0][i + 1] = line[i] == '.');
        v[0][0] = v[0][n + 1] = 1;
    }
    for (int i = 1; i < 40; ++i) {
        v[i][0] = v[i][n + 1] = 1;
        for (int j = 1; j <= n; ++j)
            ans += (v[i][j] = ((v[i - 1][j - 1] != v[i - 1][j]) ^ (v[i - 1][j] == v[i - 1][j + 1])));
    }
    for (int i = 1; i < 40; ++i) {
        for (int j = 1; j <= n; ++j)
            std::cout << (v[i][j] ? '.' : '^');
        std::cout << std::endl;
    }
    std::cout << ans << std::endl;
    return 0;
}