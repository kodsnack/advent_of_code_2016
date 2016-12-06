#include <iostream>
#include <algorithm>
#include <array>

#include "p04_data.h"

int main() {
  int ans = 0;
  int id = 0;
  std::array<int, ('z'-'a'+1)> chars;
  std::array<char, 5> key;
  bool checkkey = false;
  bool keyok = false;
  int keypos = 0;
  for(auto c : p04data) {
    switch(c) {
      case '0'...'9':
        id *= 10;
        id += (c-'0');
        break;
      case 'a'...'z':
        if(!checkkey) {
          chars[c-'a']++;
        } else {
          keyok = keyok && (key[keypos++] == c);
        }
        break;
      case '[':
        checkkey = true;
        keyok = true;
        // calc key
        for(int i = 0; i < 5; i++) {
          auto it = std::max_element(begin(chars),end(chars));
          key[i] = 'a'+std::distance(begin(chars), it);
          *it = 0;
        }
        break;
      case ']':
        if(keyok) {
          ans += id;
        }
        id = 0;
        for(auto & x : chars) x = 0;
        keyok = false;
        keypos = 0;
        checkkey = false;
        break;
      case '-':
      default: 
        break;
    }
  }
  std::cout << ans << std::endl;
}