#include <iostream>
#include <array>

namespace {
// handparsed data
constexpr std::array<std::array<int, 2>, 7> discs = {{
  {{10, 13}},
  {{15, 17}},
  {{17, 19}},
  {{1, 7}},
  {{0, 5}},
  {{1, 3}},
  {{0, 11}}
  }};

int p15_int(const int n) {
  bool found = false;
  int t = 0;
  while(!found) {
    found = true;
    for(int i = 0; i < n; i++) {
      found = found && !((discs[i][0]+t+1+i)%discs[i][1]);
    }
    t++;
  }
  return t-1;
}

}

void p15() {
  static_assert(discs.size() == 7, "");
  std::cout << p15_int(6) << std::endl;
  std::cout << p15_int(7) << std::endl;
}

int main() {
  p15();
}
