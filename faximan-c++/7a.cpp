#include <iostream>
#include <set>
#include <map>
#include <algorithm>
#include <vector>
#include <stdio.h>
#include <string>
#include <stdlib.h>

using namespace std;

bool support(const string& s) {
  bool found = false;
  for (int i = 0; i < s.length()-3; i++) {
    if (s[i] == '[' || s[i+1] == '[' || s[i] == ']' || s[i+1] == ']' || s[i] == s[i+1]) {
      continue;
    }
    if (s[i] != s[i+3] || s[i+1] != s[i+2]) {
      continue;
    }
    int j = i-1;
    for (; j >= 0; j--) {
      if (s[j] == '[') return false;
      if (s[j] == ']') {
        found = true;
        break;
      }
    }
    if (j < 0) found = true;
  }
  return found;
}

int main() {
  int res = 0;
  string s;
  while (cin >> s) {
    if (support(s)) ++res;
  }

  cout << res << endl;
  return 0;
}