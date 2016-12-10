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
  vector<string> v;
  string s;
  while(cin >> s) {
    v.push_back(s);
  } 
 
  string res = "";
  for (int i = 0; i < v[0].size(); i++) {
    vector<int> c(26);
    for (int j = 0; j < v.size(); j++) {
      c[v[j][i] - 'a']++;
    }
    int best = -1;
    for (int j = 0; j < c.size(); j++) {
      if (best == -1 || c[best] < c[j]) {
        best = j;
      }
    }
    res += ('a' + best);
  }
  cout << res << endl;
  return 0;
}