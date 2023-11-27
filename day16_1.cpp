#include <iostream>
#include <algorithm>

std::string a, b;

int main() {
    std::cin >> a;
    while (a.size() < 272u) {
        b = a;
        std::reverse(b.begin(), b.end());
        for (char &c : b) c ^= 1;
        a = a + '0' + b;
    }
    a = a.substr(0, 272);
    while (!(a.size() & 1)) {
        b.clear();
        for (unsigned i = 0; i < a.size(); i += 2) b.push_back((a[i] == a[i + 1]) | 48);
        a = b;
    }
    std::cout << a << std::endl;
    return 0;
}