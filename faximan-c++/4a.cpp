#include <iostream>
#include <set>
#include <map>
#include <algorithm>
#include <vector>
#include <stdio.h>
#include <string>
#include <stdlib.h>

using namespace std;

struct P {
  P(char cc, int ii) : c(cc),i(ii) {}
  bool operator<(const P& rhs) const {
    if (i == rhs.i) return c < rhs.c;
    return i > rhs.i;
  }
  char c;
  int i;
};

int main() {
  int res = 0;
  char c;
  while (true) {
    map<char, int>m;
    int number = 0;
    while (true) {
      c = getchar();
      if (c == '-') continue;
      if (c == '[') break;
      if (c >= '0' && c <= '9') number = number * 10 + (c - '0');
      else m[c]++;
    }
    string correct = "";
    while (true) {
      c = getchar();
      if (c == ']') break;
      correct += c;
    }
    string computed = "";
    vector<P> v;
    for (auto p : m) {
      v.emplace_back(p.first, p.second);
    }
    sort(v.begin(), v.end());
    for (int i = 0; i < 5; i++) {
      computed += v[i].c;
    }
    if (correct == computed) res += number;
    if (getchar() == EOF) break;
  }
  cout << res << endl;
  return 0;
}