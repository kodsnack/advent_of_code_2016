#include <iostream>

int n, v;

int main() {
    std::cin >> n;
    for (int i = 1; i <= n; ++i) v = (v + 2) % i;
    std::cout << v + 1;
    return 0;
}