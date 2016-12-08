#include <iostream>
#include <set>
#include <map>
#include <algorithm>
#include <vector>
#include <stdio.h>
#include <string>
#include <stdlib.h>

using namespace std;

int main() {
  string s;
  string res = "";
  int pos = 5;
  int row = 3;
  while (cin >> s) {
    for (int i = 0; i < s.length(); ++i) {
      char cur = s[i];
      if (cur == 'U') {
        if (pos == 1 || pos == 2 || pos == 4 || pos == 5 || pos == 9) continue;
        if (row == 3 || row == 4) pos -= 4;
        else pos -= 2;
        row--;
      } else if (cur == 'R') {
        if (pos == 1 || pos == 4 || pos == 9 || pos == 12 || pos == 13) continue;
        pos++;
      } else if (cur == 'D') {
        if (pos == 5 || pos == 9 || pos == 10 || pos == 12 || pos == 13) continue;
        if (row == 2 || row == 3) pos += 4;
        else pos += 2;
        row++;
      } else if (cur == 'L') {
        if (pos == 1 || pos == 2 || pos == 5 || pos == 10 || pos == 13) continue;
        pos--;
      }
    }
    if (pos < 10) {
      res += to_string(pos);
    } else {
      res += (pos - 10) + 'A';
    }
  }
  cout << res << endl;
	return 0;
}