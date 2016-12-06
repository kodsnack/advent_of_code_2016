#include <iostream>
#include <array>
#include <algorithm>

#include "p03_data.h"

int main() {
  std::array<std::array<int,3>,3> arr;
  int col = 0;
  int row = 0;
  int ans = 0;
  int num = 0;
  for(auto c : p03data) {
    switch(c) {
      case '0'...'9':
        num *=10;
        num += (c-'0');
        break;
      default:
        if(num) {
          arr[col++][row] = num;
          num = 0;
          if(col == 3) {
            row++;
            if(row == 3) {
              for(auto & a : arr) {
                std::sort(begin(a), end(a));
                if(a[0]+a[1] > a[2]) ans++;
              }
              row = 0;
            }
            col = 0;
          }
        }
        break;
    }
  } 
  std::cout << ans << std::endl;
  return 0;
}
