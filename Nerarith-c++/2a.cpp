#include <bits/stdc++.h>
#include "prettyprint.hpp"
using namespace std;

#if DEBUG
#define PRINTLN(x) \
    cerr << x << "\n"
#define PRINTSP(x) \
    cerr << x << " "
#define PRINTVEC(vec) \
    cout << "["; \
    for (int inde=0; inde < vec.size(); inde++) \
    { cout << vec[inde]; if (inde+2==vec.size()) cout << ", "; } \
    cout << "]\n";
#else
#define PRINTLN(x)
#define PRINTSP(x)
#define PRINTVEC(x)
#endif

template<> const pretty_print::delimiters_values<char> pretty_print::delimiters<std::vector<int>, char>::values = { "", " ", "" };
template<> const pretty_print::delimiters_values<char> pretty_print::delimiters<std::vector<long long>, char>::values = { "", " ", "" };
template<> const pretty_print::delimiters_values<char> pretty_print::delimiters<std::vector<double>, char>::values = { "", " ", "" };

    
int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    int keypad[3][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };

    pair<int, int> pos, newpos;     // position, first is x, second is y
    pos.first = 1; pos.second = 1;
    string movs;

    while (cin >> movs) {
        for (auto mov : movs) {
            switch (mov) {
                case 'U':
                    newpos.second--;
                    break;
                case 'D' :
                    newpos.second++;
                    break;
                case 'R':
                    newpos.first++;
                    break;
                case 'L':
                    newpos.first--;

            }
            if (newpos.first < 0 || newpos.first > 2 ||
                    newpos.second < 0 || newpos.second > 2)
                newpos = pos;
            else 
                pos = newpos;
        }
        cout << keypad[newpos.second][newpos.first];
    }
    cout << "\n";
}

