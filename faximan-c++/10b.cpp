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
#define MAX_O 30

queue<pair<int, int>> instructions[MAX_N];
queue<int> holdings[MAX_N];
int output[MAX_O];

void doit(int cur) {
  int a = holdings[cur].front();
  holdings[cur].pop();
  int b = holdings[cur].front();
  holdings[cur].pop();
  if (a > b) swap(a,b);

  auto next = instructions[cur].front();
  instructions[cur].pop();
  bool should_a, should_b;
  if (next.first >= 0) {
    holdings[next.first].push(a);
    should_a = holdings[next.first].size() > 1;
  } else {
    output[-1 * next.first] = a;
  }
  if (next.second >= 0) {
    holdings[next.second].push(b);
    should_b = holdings[next.second].size() > 1;
  } else {
    output[-1 * next.second] = b;
  }
  if (should_a) {
    doit(next.first);
  }
  if (should_b) {
    doit(next.second);
  }
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
      low = (a == "output") ? -1 * low - 1 : low;
      high = (b == "output") ? -1 * high - 1 : high;
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
  cout << output[1] * output[2] * output[3] << endl;
  return 0;
}