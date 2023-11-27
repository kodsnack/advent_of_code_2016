#include <iostream>
#include <set>
#include "pystrlib.hpp"

std::set<std::string> check(const std::string &s) {
    int len = s.size();
    std::set<std::string> ans;
    for (int i = 2; i < len; ++i)
        if (s[i - 2] == s[i] && s[i] != s[i - 1]) ans.insert(std::string() + s[i] + s[i - 1]);
    return ans;
}

inline void insert_all(std::set<std::string> &A, const std::set<std::string> &B) { A.insert(B.begin(), B.end()); }

int main() {
    freopen("day7.txt", "r", stdin);
    freopen("day7_o.txt", "w", stdout);
    int ans = 0;
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::string> v = lib::split(line, "[");
            std::set<std::string> aba = check(v[0]), bab;
            bool ok = false;
            for (unsigned i = 1; i < v.size(); ++i) {
                auto [in, _, out] = lib::partition(v[i], "]");
                insert_all(bab, check(in)); insert_all(aba, check(out));
            }
            for (const std::string &ab : aba)
                if (bab.count(std::string() + ab[1] + ab[0])) { ok = true; break; }
            ans += ok;
            std::cout << ans << std::endl;
        }
    }
    std::cout << ans << std::endl;
    return 0;
}