#include <iostream>
#include <set>
#include <map>
#include <algorithm>
#include <vector>
#include <stdio.h>

using namespace std;

int main() {
  char c;
  int d;
  int dir = 0;
  int a = 0;
  int b = 0;
  set<pair<int, int>> m;
  m.emplace(0,0);
  while (true) {
    scanf("%c%d", &c, &d);
    if (c == 'R') {
      dir = (dir + 1) % 4;
    } else {
      dir -= 1;
      if (dir < 0) dir += 4;
    }

    for (int i = 0; i < d; i++) {
      if (dir == 0) {
        a++;
      } else if (dir == 1) {
        b++;
      } else if (dir == 2) {
        a--;
      } else {
        b--;
      }
      auto p = make_pair(a, b);
      if (m.count(p) != 0) {
        cout << abs(a) + abs(b) << endl;
        return 0;
      }
      m.insert(p);
    }
    if (getchar() == EOF) break;
    getchar();  
  }
	return 0;
}