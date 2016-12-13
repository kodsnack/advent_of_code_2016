#include <iostream>
#include <tuple>
#include <deque>
#include <set>

namespace {
constexpr int data = 1362;
constexpr int targetx = 31;
constexpr int targety = 39;
constexpr int targetrounds = 50;

bool isWall(int x, int y) {
  int tmp = x*x + 3*x + 2*x*y + y + y*y + data;
  bool ret = false;
  while(tmp) {
    ret = ret ^ (tmp & 1);
    tmp >>= 1;
  }
  return ret;
}

}

void p13() {
  std::set<std::tuple<int,int>> visited;
  std::deque<std::tuple<int,int,int>> queue;

  visited.insert(std::make_tuple(1,1));
  queue.emplace_back(std::make_tuple(0,1,1));

  int ans1 = 0;
  int ans2 = 0;
  while(!queue.empty()) {
    int r = std::get<0>(queue.front());
    int x = std::get<1>(queue.front());
    int y = std::get<2>(queue.front());
    queue.pop_front();
    if(x == targetx && y == targety) {
      ans1 = r;
    }

    if(r <= targetrounds) ans2++;
    else if(ans1) continue; // stop adding states if answer 1 found and number of rounds reached

    for(int dx = -1; dx < 2; dx++) {
      for(int dy = -1; dy < 2; dy++) {
        if((dx && dy) || (!dx && !dy)) continue;
        if((x+dx)>=0 && (y+dy)>=0 && !isWall(x+dx, y+dy)) {
          auto point = std::make_tuple(x+dx, y+dy);
          if(visited.find(point) == end(visited)) {
            visited.insert(point);
            queue.emplace_back(std::make_tuple(r+1, x+dx, y+dy));
          }
        }
      }
    }
  }
  std::cout << ans1 << std::endl;
  std::cout << ans2 << std::endl;  
}

int main() {
  p13();
}
