#include <bits/stdc++.h>
#include "prettyprint.hpp"
using namespace std;

#if DEBUG
#define PRINTLN(var1) \
    cerr << var1 << "\n"
#define PRINTLN2(var1, var2) \
    cerr << var1 << var2 << "\n"
#define PRINTSP(var1) \
    cerr << var1 << " "
#define PRINTSP2(var1, var2) \
    cerr << var1 << var2 << " "
#define PRINTVEC(vec) \
    cout << "["; \
    for (int inde=0; inde < vec.size(); inde++) \
    { cout << vec[inde]; if (inde+2==vec.size()) cout << ", "; } \
    cout << "]\n"
#else
#define PRINTLN(var1)
#define PRINTLN2(var1, var2)
#define PRINTSP(var1)
#define PRINTSP2(var1, var2)
#define PRINTVEC(var1)
#endif


int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    
    struct Position {
        int x, y;
    } pos;
    pos.x = 0; pos.y = 0;
    int dir = 0;    // the direction represented by 0-3, North, East, South, West
    char turn;
    int mov;
    while (true) {
        scanf("%c%d,", &turn, &mov);
        dir = (dir + (turn == 'R' ? 1 : 3)) % 4;
        switch (dir) {
            case 0:
                pos.y += mov;
                break;
            case 1:
                pos.x += mov;
                break;
            case 2:
                pos.y -= mov;
                break;
            case 3:
                pos.x -= mov;
                break;
        }
        PRINTSP2("move: ", mov); PRINTSP2("  dir: ", dir);
        PRINTSP2("  pos: ", pos.x); PRINTLN(pos.y);
        if (getchar() == EOF)
            break;
    }

    cout << abs(pos.x) + abs(pos.y) << "\n";
    PRINTSP(pos.x); PRINTLN(pos.y);
}

