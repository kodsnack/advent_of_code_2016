#include <iostream>
#include <array>
#include <tuple>
#include <deque>
#include <set>
#include <algorithm>

#include "p24_data.h"
constexpr int SX = 183;
constexpr int SY = 37;
constexpr int N = 8;

int getmin(const int c, const std::array<std::array<int,N>,N> & d, std::array<int,N> & v, int r = 0) {
  int ret = d[0][c]*r;
  for(auto a : v) ret *= a;

  for(int i = 0; i < N; i++) {
    if(v[i]) continue;
    v[i] = 1;
    int tmp = getmin(i, d, v, r) + d[c][i];
    v[i] = 0;
    if(tmp) if(!ret || tmp < ret) ret = tmp;
  }
  return ret;
}

int main() {
  const char *c = p24data;
  std::array<std::array<char, SX>, SY> maze;
  std::array<std::tuple<int,int>, N> points;
  std::array<std::array<int, N>, N> distances;

  int rowlen = 0;
  int rows = 0;
  while(*c) {
    switch(*c) {
      case '\n':
        rows++;
        rowlen = 0;
        break;
      case '0'...'9':
        points[*c-'0'] = std::make_tuple(rows, rowlen);
      default:
        maze[rows][rowlen] = *c;
        rowlen++;
        break;
    }
    c++;
  }

  for(size_t i = 0; i < points.size(); i++) {
    int x,y;
    std::tie(x,y) = points[i];
    std::deque<std::tuple<int, std::tuple<int, int>>> queue;
    std::set<std::tuple<int,int>> visited;
    int found = 0;

    queue.emplace_back(0, points[i]);
    visited.emplace(points[i]);

    while(!queue.empty() && found < N) {
      int r, x, y;
      std::tuple<int, int> p;
      std::tie(r, p) = queue.front();
      std::tie(y, x) = p;
      auto it = std::find(begin(points), end(points), p);
      if(it != end(points)) {
        found++;
        distances[i][std::distance(begin(points), it)] = r;
      }
      queue.pop_front();
      for(int dy = -1; dy < 2; dy++) {
        for(int dx = -1; dx < 2; dx++) {
          if(dy && dx) continue;
          if(dy == dx) continue;
          if(maze[y+dy][x+dx] == '#') continue;
          auto np = std::make_tuple(y+dy, x+dx);
          if(visited.find(np) != end(visited)) continue;
          visited.insert(np);
          queue.emplace_back(r+1, np);
        }
      }
    }
  }

  std::array<int,N> v;
  for(auto & c : v) c = 0;
  v[0] = 1;
  auto ans = getmin(0, distances, v);
  std::cout << ans << std::endl;
  auto ans2 = getmin(0, distances, v, 1);
  std::cout << ans2 << std::endl;

}
