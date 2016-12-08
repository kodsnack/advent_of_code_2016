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
  int res = 0;
  int a[3];
  while (scanf("%d %d %d", &a[0], &a[1], &a[2]) != EOF) {
    sort(a, a+3);
    if (a[0] + a[1] > a[2]) ++res;
  }
  cout << res << endl;
	return 0;
}