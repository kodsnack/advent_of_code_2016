#include <iostream>
#include "pystrlib.hpp"

bool check(const std::string &s) {
    int len = s.size();
    for (int i = 3; i < len; ++i)
        if (s[i - 3] == s[i] && s[i - 2] == s[i - 1] && s[i] != s[i - 1]) return true;
    return false;
}

int main() {
    freopen("day7.txt", "r", stdin);
    int ans = 0;
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::string> v = lib::split(line, "[");
            bool f1 = false, f2 = false;
            f1 |= check(v[0]);
            for (unsigned i = 1; i < v.size(); ++i) {
                auto [in, _, out] = lib::partition(v[i], "]");
                f2 |= check(in); f1 |= check(out);
            }
            ans += !f2 && f1;
        }
    }
    std::cout << ans << std::endl;
    return 0;
}