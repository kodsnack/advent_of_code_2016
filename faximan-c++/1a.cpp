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
  while (true) {
    scanf("%c%d", &c, &d);
    if (c == 'R') {
      dir = (dir + 1) % 4;
    } else {
      dir -= 1;
      if (dir < 0) dir += 4;
    }
    if (dir == 0) {
      a += d;
    } else if (dir == 1) {
      b += d;
    } else if (dir == 2) {
      a -= d;
    } else {
      b -= d;
    }
    if (getchar() == EOF) break;
    getchar();
  }
  cout << abs(a) + abs(b) << endl;
	return 0;
}