#include <iostream>
#include "pystrlib.hpp"

struct Node {
    unsigned tag, sum, l, r;
    int ls, rs;
} N[20000005];
int cnt, root;

inline int new_node(unsigned l, unsigned r) { N[++cnt] = { 0, 0, l, r, 0, 0 }; return cnt; }

inline void push_down(int k) {
    if (!N[k].tag) return;
    unsigned mid = ((unsigned long long) N[k].l + N[k].r) >> 1;
    N[N[k].ls].sum = mid - N[k].l + 1; N[N[k].rs].sum = N[k].r - mid;
    N[N[k].ls].tag = N[N[k].rs].tag = 1;
    N[k].tag = 0;
}

void update(unsigned x, unsigned y, int k) {
    if (x <= N[k].l && N[k].r <= y) { N[k].tag = 1; N[k].sum = N[k].r - N[k].l + 1u; return; }
    unsigned mid = ((unsigned long long) N[k].l + N[k].r) >> 1;
    if (!N[k].ls) N[k].ls = new_node(N[k].l, mid);
    if (!N[k].rs) N[k].rs = new_node(mid + 1, N[k].r);
    push_down(k);
    if (x <= mid) update(x, y, N[k].ls);
    if (mid < y) update(x, y, N[k].rs);
    N[k].sum = N[N[k].ls].sum + N[N[k].rs].sum;
}

int query(int k) {
    if (N[k].l == N[k].r) return N[k].l;
    unsigned mid = ((unsigned long long) N[k].l + N[k].r) >> 1;
    if (!N[k].ls) N[k].ls = new_node(N[k].l, mid);
    if (!N[k].rs) N[k].rs = new_node(mid + 1, N[k].r);
    push_down(k);
    return query(N[N[k].ls].sum != mid - N[k].l + 1 ? N[k].ls : N[k].rs);
}

int main() {
    freopen("day20.txt", "r", stdin);
    root = new_node(0u, 4294967295u);
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            auto [f, _, t] = lib::partition(line, "-");
            update(std::stoul(f), std::stoul(t), root);
        }
    }
    std::cout << query(root) << std::endl;
    return 0;
}