#include <iostream>

#include "quick.h"
#include "md5_util.h"

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
    auto r = md5::md5(s.c_str(), s.length())[0];
    if((r & 0xf0ffff) == 0) {
      auto tmp = ((r&0xf0000)>>16);
      if(tmp < 10) ans += ('0'+tmp);
      else ans += (tmp-10+'a');
    }
    i++;
  }

  std::cout << ans << std::endl;
}
