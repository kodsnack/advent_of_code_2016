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
  bool in = false;
  set<pair<string,bool>> mys;
  for (int i = 0; i < s.length()-2; i++) {
    if (s[i] == '[') {
      in = true;
    } else if (s[i] == ']') {
      in = false;
    } else {
      if (s[i] == s[i+1] || s[i] != s[i+2]) {
        continue;
      }
      string a = to_string(s[i]);
      string b = to_string(s[i+1]);
      string my = a + b + a;
      if (in) {
        my = b + a + b;
      }
      if (mys.count(make_pair(my,!in)) != 0) return true;
      mys.insert(make_pair(my,in));
    }
  }
  return false;
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