#include <iostream>

inline int j(int a, int b, int c) { return a + b > c && b + c > a && c + a > b; }

int main() {
    freopen("day3.txt", "r", stdin);
    int p = 0, a1, b1, c1, a2, b2, c2, a3, b3, c3;
    while (std::cin >> a1 >> a2 >> a3 >> b1 >> b2 >> b3 >> c1 >> c2 >> c3) p += j(a1, b1, c1) + j(a2, b2, c2) + j(a3, b3, c3);
    std::cout << p << std::endl;
    return 0;
}