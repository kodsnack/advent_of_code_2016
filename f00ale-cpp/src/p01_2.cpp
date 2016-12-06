#include <iostream>
#include <string>
#include <tuple>
#include <set>
const char data[] = R"(
R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, 
L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, 
R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2
)";

int dir[4][2] = {
  {1, 0},
  {0, 1},
  {-1, 0},
  {0, -1}
};

int main() {
  int x = 0, y = 0;
  int d = 0;
  int step = 0;
  std::set<std::tuple<int,int>> visited;
  visited.insert(std::make_tuple(x,y));

  for(auto c : data) {
    switch(c) {
    case '0'...'9':
      step *= 10;
      step += (c-'0');
      break;
    case 'R':
      if(step) std::cerr << "Got R with non-zero step" << std::endl;
      d++;
      if(d>=4) d = 0;
      break;
    case 'L':
      if(step) std::cerr << "Got L with non-zero step" << std::endl;
      d--;
      if(d<0) d = 3;
      break;
    case ',':
    default:
      for(int i = 0; i < step; i++) {
        y+=dir[d][0];
        x+=dir[d][1];
        if(visited.find(std::make_tuple(x,y)) == visited.end()) {
          visited.insert(std::make_tuple(x,y));
        } else {
          std::cout << (abs(x)+abs(y)) << std::endl;
          return 0;
        }
      }
      step = 0;
      break;
    }
  }
  std::cout << "Solution not found!" << std::endl;
  return 0;
}
