#include <iostream>
#include <set>
#include <map>
#include <algorithm>
#include <vector>
#include <stdio.h>
#include <string>
#include <sstream>
#include <stdlib.h>

using namespace std;

long long solve(const string& s, int pos, int length) {
  long long res = 0;
  for (int i = pos; i < pos + length; i++) {
    if (s[i] == '(') {
      i++;
      int a = (s[i] - '0');
      i++;
      while (s[i] != 'x') {
        a = a * 10 + (s[i] - '0');
        i++;
      }
      i++;
      int b = (s[i] - '0');
      i++;
      while (s[i] != ')') {
        b = b * 10 + (s[i] - '0');
        i++;
      }
      i++;
      res += b * solve(s, i, a);
      i += a-1;
    } else {
      res++;
    }
  }
  return res;
}

int main() {
  string s,t;
  while (cin >> t) {
    s += t;
  }
  cout << solve(s, 0, s.length()) << endl;
  return 0;
}