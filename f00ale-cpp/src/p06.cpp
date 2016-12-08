#include <iostream>
#include <array>
#include <algorithm>

#include "p06_data.h"

int main() {
  std::array<std::array<int, 'z'-'a'+1>,8> freqtable;
  for(auto & arr : freqtable) for(auto & c : arr) c=0;

  int pos = 0;
  for(auto c : p06data) {
    switch(c) {
    case 'a'...'z':
      freqtable[pos++][c-'a']++;
      break;
    default:
      pos = 0;
      break;
    }
  }

  std::string ans1, ans2;

  for(auto & arr : freqtable) {
    auto it1 = std::max_element(begin(arr),end(arr));
    ans1.push_back((char)('a'+std::distance(begin(arr), it1)));
    auto it2 = std::min_element(begin(arr),end(arr));
    ans2.push_back((char)('a'+std::distance(begin(arr), it2)));
  }
  std::cout << ans1 << std::endl;
  std::cout << ans2 << std::endl;
  return 0;
}
