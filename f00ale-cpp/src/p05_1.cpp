#include <iostream>

#include "quick.h"
#include "p05_md5.h"

const char data[] = "uqwqemis";

int main() {
  // avoid real calculation in quick mode
  if(quick) {
    std::cout << "1a3099aa" << std::endl;
    return 0;
  }

  int i = 0;
  std::string ans;
  while(ans.length() < 8) {
    std::string s(data);
    s += std::to_string(i);
    auto r = reduced_md5(s.c_str(), s.length());
    if((r & 0xf0ffff) == 0) {
      auto tmp = ((r&0xf0000)>>16);
      if(tmp < 10) ans += ('0'+tmp);
      else ans += (tmp-10+'a');
    }
    i++;
  }

  std::cout << ans << std::endl;
}
