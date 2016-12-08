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
  char c;
  const string to_find = "northpole-object-storage-";
  while (true) {
    int number = 0;
    string s = "";
    while (true) {
      c = getchar();
      if (c == '[') break;
      if (c >= '0' && c <= '9')  {
        number = number * 10 + (c - '0');
        continue;
      }
      s += c;
    }
    for (int i = 0; i < s.length(); i++) {
      if (s[i] < 'a' || s[i] > 'z') continue;
      s[i] = (((s[i] - 'a') + (number % 26)) % 26) + 'a';
    }
    if (s == to_find) {
      cout << number << endl;
    }
    while (true) {
      c = getchar();
      if (c == ']') break;
    }
    if (getchar() == EOF) break;
  }
  return 0;
}