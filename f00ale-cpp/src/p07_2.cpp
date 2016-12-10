#include <iostream>
#include <array>
#include <vector>
#include "p07_data.h"

int main() {
  std::array<char,3> chars;
  std::vector<decltype(chars)> abas, babs;
  int cpos = 0;
  int ans = 0;
  bool inbrac = false, found = false;
  for(auto c : p07data) {
    switch(c) {
      case 'a'...'z':
        if(cpos < 3) chars[cpos++] = c;
        else {
          chars[0] = chars[1];
          chars[1] = chars[2];
          chars[2] = c;
        }
        if(cpos == 3) {
          if(chars[0]==chars[2] && chars[0] != chars[1]) {
            if(inbrac) babs.push_back(chars);
            else abas.push_back(chars);
          } 
        }
        break;
      case '[':
        inbrac = true;
        cpos = 0;
        break;
      case ']':
        inbrac = false;
        cpos = 0;
        break;
      default:
        for(auto & aba : abas) {
          for(auto & bab : babs) {
            if(aba[0] == bab[1] && aba[1] == bab[0]) found = true;
          }
        }
        if(found) ans++;
        abas.clear();
        babs.clear();
        found = false;
        inbrac = false;
        cpos = 0;
        break;
    }
  }  
  std::cout << ans << std::endl;
  return 0;
}
