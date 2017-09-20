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

    int keypad[5][5] = {
        {-1, -1, 1, -1, -1},
        {-1, 2, 3, 4, -1},
        {5, 6, 7, 8, 9},
        {-1, 'A', 'B', 'C', -1},
        {-1, -1, 'D', -1, -1}
    };

    pair<int, int> pos, newpos;     // position, first is x, second is y
    pos.first = 2; pos.second = 2;
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
            if (abs(newpos.first-2) + abs(newpos.second-2) > 2)
                newpos = pos;
            else 
                pos = newpos;
        }
        int toPrint = keypad[newpos.second][newpos.first];
        if (toPrint < 10)
            cout << toPrint;
        else
            cout << (char) toPrint;
    }
    cout << "\n";
}

