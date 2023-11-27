#include <iostream>

int main() {
    freopen("day3.txt", "r", stdin);
    int p = 0, a, b, c;
    while (std::cin >> a >> b >> c) p += a + b > c && b + c > a && c + a > b;
    std::cout << p << std::endl;
    return 0;
}