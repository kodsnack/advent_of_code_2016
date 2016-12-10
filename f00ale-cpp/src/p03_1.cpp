#include <iostream>
#include <array>
#include <algorithm>

#include "p03_data.h"

int main() {
  std::array<int,3> arr;
  int ant = 0;
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
          arr[ant++] = num;
          num = 0;
          if(ant == 3) {
            std::sort(begin(arr), end(arr));
            if(arr[0]+arr[1] > arr[2]) ans++;
            ant = 0;
          }
        }
        break;
    }
  } 
  std::cout << ans << std::endl;
  return 0;
}
