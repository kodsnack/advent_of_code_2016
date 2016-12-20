#include <iostream>
#include <algorithm>
#include <vector>
#include <tuple>
#include <stdint.h>

#include "p20_data.h"

int main() {
  std::vector<std::tuple<int64_t, int64_t>> v;
  int64_t d1 = 0, d2 = 0;
  bool f = true;
  for(auto c : p20data) {
    switch(c) {
      case '0'...'9':
        if(f) {
          d1*=10;
          d1+=(c-'0');
        } else {
          d2*=10;
          d2+=(c-'0');
        }
        break;
      case '-':
        f = false;
        break;
      default:
        if(d2 > d1) v.emplace_back(d1,d2);
        d1 = d2 = 0;
        f = true;
        break;
    }
  }

  std::sort(begin(v), end(v));
  int64_t l = 0, ans1 = 0, ans2 = 0;
  for(auto t : v) {
    int64_t a,b;
    std::tie(a,b) = t;
    if(l < a) {
      if(!ans1) ans1 = l;
      ans2 += a-l;
    }
    if(l < b+1) l = b+1;
  }
  ans2 += (UINT32_MAX-l)+1;
  std::cout << ans1 << std::endl;
  std::cout << ans2 << std::endl;
  return 0;
}
