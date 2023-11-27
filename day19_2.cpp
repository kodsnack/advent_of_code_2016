#include <iostream>

int n, v;

int main() {
    std::cin >> n;
    for (int i = 5; i <= n; ++i) v = ((v <= (i >> 1) - 2) ? (v + 1) : (v + 2)) % i;
    std::cout << v + 1 << std::endl;
    return 0;
}