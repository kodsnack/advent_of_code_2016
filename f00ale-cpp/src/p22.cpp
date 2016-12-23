#include <iostream>
#include <array>
#include <deque>
#include <tuple>
#include <set>

#include "p22_data.h"

namespace {

struct data {
  int size;
  int used;
};

struct point {
  int x, y;
};

bool operator<(const point & c1, const point & c2) {
  return std::tie(c1.x,c1.y)<std::tie(c2.x,c2.y);
}

bool operator==(const point & c1, const point & c2) {
  return std::tie(c1.x,c1.y)==std::tie(c2.x,c2.y);
}

constexpr int SX = 35;
constexpr int SY = 29;

void dump(const std::array<std::array<char, SY>, SX> & arr) {
  for(auto & c : arr) {
    for(auto & r : c) std::cout << " " << r; std::cout << std::endl;
  }
}

template<size_t Y, size_t X>
auto createMaze(const std::array<std::array<data, Y>, X> & arr, const int threshold) {
  std::array<std::array<char, Y>, X> ret;
  for(size_t x = 0; x < X; x++) {
    for(size_t y = 0; y < Y; y++) {
      ret[x][y] = arr[x][y].used == 0 ? '_' : (arr[x][y].size < threshold ? '.' : '#');
    }
  }
  ret[0][0] = 'G';
  ret[X-1][0] = 'D';
  return ret;
}

}

void p23() {
  std::array<std::array<data, SY>, SX> arr;
  std::array<std::array<char, SY>, SX> maze;
  constexpr point goal{0,0}, data{SX-1, 0};
  point empty{-1,-1};

  const char *c = p22data;
  
  std::array<int, 6> r;
  int ns = 0, num = -1;
  while(*c) {
    switch(*c) {
      case '0'...'9':
        if(num < 0) num = 0;
        num *= 10;
        num += (*c-'0');
        break;
      default:
        if(num >= 0) {
          r[ns++] = num;
          if(ns == 6) {
            ns = 0;
            arr[r[0]][r[1]] = {r[2], r[3]};
          }
        }
        num = -1;
        break;
    }
    c++;
  }

  for(auto & r : maze) for(auto & c : r) c = '#';
  int ans1 = 0;
  for(int ax = 0; ax < SX; ax++) {
    for(int ay = 0; ay < SY; ay++) {
      for(int bx = 0; bx < SX; bx++) {
        for(int by = 0; by < SY; by++) {
          if(ax == bx && ay == by) continue;
          if(arr[ax][ay].used <= (arr[bx][by].size-arr[bx][by].used)) {
            maze[ax][ay] = '.';
            if(arr[ax][ay].used) ans1++;
            else empty = {ax, ay};
          }
        }    
      }
    }    
  }

  std::cout << ans1 << std::endl;
  if(false) dump(maze); // quiet ununsed warning

  std::deque<std::tuple<int, point, point>> queue; // round, (x,y) of empty, (x,y) of data
  std::set<std::tuple<point, point>> visited; // (x,y) of empty, (x,y) of data
  queue.emplace_back(0, empty, data);
  visited.emplace(empty, data);

  while(!queue.empty()) {
    point e, d;
    int rn;
    std::tie(rn, e, d) = queue.front();

    if(d == goal) break;

    queue.pop_front();
    for(int dx = -1; dx < 2; dx++) {
      for(int dy = -1; dy < 2; dy++) {
        if(dx && dy) continue; // either x or y has to be zero
        if(dx == dy) continue; // ... but not both
        point np{e.x+dx, e.y+dy};
        if(np.x < 0 || np.x >= SX || np.y < 0 || np.y >= SY) continue;
        if(maze[np.x][np.y] != '#') { // move possible
          auto nd = np==d ? e : d; // check if we're moving the data we're interested in.
          auto st = std::make_tuple(np, nd);
          if(visited.find(st) != end(visited)) continue;
          visited.insert(st);
          queue.emplace_back(rn+1, np, nd);
        }
      }    
    }
  }

  if(!queue.empty()) std::cout << std::get<0>(queue.front()) << std::endl;
  else std::cout << "NOT FOUND" << std::endl;
}

int main() {
  p23();
}
