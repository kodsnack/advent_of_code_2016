#include <iostream>
#include <deque>
#include <vector>

namespace {
int p19_1(const int num) {
  std::deque<int> q;
  for(int i = 0; i < num; i++) {
    q.push_back(i+1);
  }
  while(q.size() > 1) {
    auto f = q.front();
    q.pop_front();
    q.pop_front();
    q.push_back(f);
  }
  return q.front();
}

int p19_2(const int num) {
  std::deque<int> q1, q2;
  for(int i = 0; i < num/2; i++) {
    q1.push_back(i+1);
  }
  for(int i = num/2; i < num; i++) {
    q2.push_back(i+1);
  }
  while(!q1.empty()) {
    auto f = q1.front();
    q1.pop_front();
    q2.pop_front();

    if(q1.size() < q2.size()) {
      q1.push_back(q2.front());
      q2.pop_front();
    }

    q2.push_back(f);
  }
  return q2.front();
}
}

void p19() {
  std::cout << p19_1(3012210) << std::endl;
  std::cout << p19_2(3012210) << std::endl;
}

int main() {
  p19();
}

