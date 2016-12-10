#include <iostream>
#include <set>
#include <map>
#include <algorithm>
#include <vector>
#include <stdio.h>
#include <string>
#include <sstream>
#include <stdlib.h>
#include <queue>

using namespace std;

#define MAX_N 301

queue<pair<int, int>> instructions[MAX_N];
queue<int> holdings[MAX_N];

bool doit(int cur) {
  int a = holdings[cur].front();
  holdings[cur].pop();
  int b = holdings[cur].front();
  holdings[cur].pop();
  if (a > b) swap(a,b);
  if (a == 17 && b == 61) {
    cout << cur << endl;
    return true;
  }

  auto next = instructions[cur].front();
  instructions[cur].pop();
  bool should_a, should_b;
  if (next.first != -1) {
    holdings[next.first].push(a);
    should_a = holdings[next.first].size() > 1;
  }
  if (next.second != -1) {
    holdings[next.second].push(b);
    should_b = holdings[next.second].size() > 1;
  }
  if (should_a) {
    if (doit(next.first)) {
      return true;
    }
  }
  if (should_b) {
    if (doit(next.second)) {
      return true;
    }
  }
  return false;
}

int main() {
  string s;
  int cur;
  while (getline(cin, s)) {
    stringstream ss(s);
    string dummy, a, b;
    int bot, high, low;
    if (s[0] == 'b') {
      ss >> dummy >> bot >> dummy >> dummy >> dummy >> a >> low >> dummy >> dummy >> dummy >> b >> high;
      low = (a == "output") ? -1 : low;
      high = (b == "output") ? -1 : high;
      instructions[bot].push(make_pair(low, high));
    } else {  
      ss >> dummy >> low >> dummy >> dummy >> dummy >> bot;
      holdings[bot].push(low);
      if (holdings[bot].size() > 1) {
        cur = bot;
      } 
    }
  }
  doit(cur);
  return 0;
}