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

bool mat[50][6];

int main() {
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < 6; j++) {
      mat[i][j] = false;
    }
  }

  string s;
  while (getline(cin,s)) {
    if (s[1] == 'e') {
      s = s.substr(5);
      stringstream ss(s);
      int a, b;
      char c;
      ss >> a >> c >> b;
      for (int i = 0; i < a; i++) {
        for (int j = 0; j < b; j++) {
          mat[i][j] = true;
        }
      }
    } else if (s[7] == 'c') {
      s = s.substr(16);
      stringstream ss(s);
      int a, b;
      string c;
      ss >> a >> c >> b;
      for (int k = 0; k < b; k++) {
        bool carry = mat[a][0];
        for (int i = 1; i < 6; i++) {
          swap(carry, mat[a][i]);
        }
        mat[a][0] = carry;
      }
    } else {
      s = s.substr(13);
      stringstream ss(s);
      int a, b;
      string c;
      ss >> a >> c >> b;
      for (int k = 0; k < b; k++) {
        bool carry = mat[0][a];
        for (int i = 1; i < 50; i++) {
          swap(carry, mat[i][a]);
        }
        mat[0][a] = carry;
      }
    }
  }
  

  int res = 0;
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < 6; j++) {
      if (mat[i][j]) ++res;
    }
  }
  cout << res << endl;
  return 0;
}