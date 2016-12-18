#include <iostream>
#include <deque>
#include <tuple>
#include <string>
#include <array>

#include "md5_util.h"

int main() {
  std::deque<std::tuple<int, int, std::string>> queue;
  constexpr std::array<std::tuple<char, int, int>, 4> steps{{
    std::make_tuple('U',  0, -1),
    std::make_tuple('D',  0,  1),
    std::make_tuple('L', -1,  0),
    std::make_tuple('R',  1,  0)
  }};
  const std::string code = "pvhmgsws";
  std::string ans;
  queue.emplace_back(0,0,"");
  while(!queue.empty()) {
    std::string path;
    int x, y;
    tie(x,y,path) = queue.front();
    queue.pop_front();
    if(x == 3 && y == 3) {
      ans = path;
      break;
    }
    std::string data = code + path;
    auto md = md5::tochars(md5::md5(data.c_str(), data.length()));
    for(int m = 0; m < 4; m++) {
      if(md[m] >= 'b') {
        auto nx = x+std::get<1>(steps[m]);
        auto ny = y+std::get<2>(steps[m]);
        if(nx < 0 || nx > 3 || ny < 0 || ny > 3) continue;
        queue.emplace_back(nx,ny,path+std::get<0>(steps[m]));
      }
    }
  }
  std::cout << ans << std::endl;
}
