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
  int a[9];
  while (scanf("%d %d %d", &a[0], &a[3], &a[6]) != EOF) {
  	scanf("%d %d %d", &a[1], &a[4], &a[7]);
  	scanf("%d %d %d", &a[2], &a[5], &a[8]);
    sort(a, a+3);
    sort(a+3, a+6);
    sort(a+6, a+9);
    if (a[0] + a[1] > a[2]) ++res;
    if (a[3] + a[4] > a[5]) ++res;
    if (a[6] + a[7] > a[8]) ++res;
  }
  cout << res << endl;
  return 0;
}