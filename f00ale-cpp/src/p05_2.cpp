#include <iostream>

#include "quick.h"
#include "p05_md5.h"

const char data[] = "uqwqemis";
bool cinematic = true;

int main() {
  // avoid real calculation in quick mode
  if(quick) {
    std::cout << "694190cd" << std::endl;
    return 0;
  }

  int found = 0;
  int i = 0;
  std::string ans("        ");
  if(cinematic) std::cout << std::endl;
  while(found < 8) {
    std::string s(data);
    s += std::to_string(i);
    auto r = reduced_md5(s.c_str(), s.length());
    if((r & 0xf8ffff) == 0) {
      auto pos = ((r&0x70000)>>16);
      auto tmp = ((r&0xf0000000)>>28);
      char hexchar = (tmp<10)?('0'+tmp):(tmp-10+'a');
      if(ans[pos] == ' ') {
        found++;
        ans[pos] = hexchar;
        if(cinematic) std::cout << ans << '\r' << std::flush;
      }
    }
    i++;
  }
  if(cinematic) std::cout << std::endl;
  std::cout << ans << std::endl;
}
