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
  while (cin >> s) {
    for (int i = 0; i < s.length(); ++i) {
      char cur = s[i];
      if (cur == 'U') {
        if (pos == 1 || pos == 2 || pos == 3) continue;
        pos -= 3;
      } else if (cur == 'R') {
        if (pos == 3 || pos == 6 || pos == 9) continue;
        pos++;
      } else if (cur == 'D') {
        if (pos == 7 || pos == 8 || pos == 9) continue;
        pos += 3;
      } else if (cur == 'L') {
        if (pos == 1 || pos == 4 || pos == 7) continue;
        pos--;
      } else {
        cout << "ERROR " << pos << endl; 
      }
    }
    res += to_string(pos);
  }
  cout << res << endl;
	return 0;
}