#include <iostream>
#include <tuple>
#include <deque>
#include <set>

constexpr int data = 1362;

bool isWall(int x, int y) {
  int tmp = x*x + 3*x + 2*x*y + y + y*y + data;
  bool ret = false;
  while(tmp) {
    ret = ret ^ (tmp & 1);
    tmp >>= 1;
  }
  return ret;
}


int main() {
  std::set<std::tuple<int,int>> visited;
  std::deque<std::tuple<int,int,int>> queue;

  visited.insert(std::make_tuple(1,1));
  queue.emplace_back(std::make_tuple(0,1,1));

  while(!queue.empty()) {
    int r = std::get<0>(queue.front());
    int x = std::get<1>(queue.front());
    int y = std::get<2>(queue.front());
    queue.pop_front();
    if(r == 50) continue;

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
  std::cout << visited.size() << std::endl;
}
