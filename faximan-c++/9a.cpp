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

int main() {
  string s,t;
  while (cin >> t) {
    s += t;
  }
  stringstream ss(s);
  char c;
  int r = 0;
  while (ss >> c) {
    if (c == '(') {
      int a, b;
      ss >> a >> c >> b >> c;
      for (int i = 0; i < a; i++) {
        ss >> c;
      }
      r += a * b;
    } else {
      r++;
    }
  }
  cout << r << endl;
  return 0;
}