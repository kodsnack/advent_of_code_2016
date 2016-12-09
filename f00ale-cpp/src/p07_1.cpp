#include <iostream>

#include "p07_data.h"

int main() {
  char chars[4];
  int cpos = 0;
  bool inbrac = false, disc = false, haveabba = false;
  int ans = 0;
  for(auto c : p07data) {
    switch(c) {
      case 'a'...'z':
        if(cpos < 4) chars[cpos++] = c;
        else {
          chars[0] = chars[1];
          chars[1] = chars[2];
          chars[2] = chars[3];
          chars[3] = c;
        }
        if(cpos == 4) {
          if(chars[0]==chars[3] && chars[1] == chars[2] && chars[0] != chars[1]) {
            haveabba = true;
            if(inbrac) disc = true;
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
        if(haveabba && !disc) {
          ans++;
        }
        haveabba = false;
        disc = false;
        inbrac = false;
        cpos = 0;
        break;
    }
  }  
  std::cout << ans << std::endl;
  return 0;
}
