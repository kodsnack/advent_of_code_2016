#include <iostream>
#include <array>

namespace {
// handparsed data
constexpr std::array<std::array<int, 2ul>, 6ul> discs1 = {{
  {{10, 13}},
  {{15, 17}},
  {{17, 19}},
  {{1, 7}},
  {{0, 5}},
  {{1, 3}}
}};

template<typename T, long unsigned S>
constexpr std::array<T,S+1> array_append(const std::array<T,S> & arr, const T & e) {
  std::array<T,S+1> ret{};
  std::copy(begin(arr), end(arr), begin(ret));
  ret[S] = e;
  return ret;
}

auto discs2 = array_append(discs1, {{0,11}});

template<typename T, long unsigned S>
constexpr T chinese_remainder(const std::array<std::array<T, 2>, S> & coeff) {
  T ret = 0;
  T M = 1;
  for(auto & a : coeff) M *= a[1];

  std::array<T, S> b = {};

  for(decltype(S) i = 0; i < S; i++) {
    auto tmp = M / coeff[i][1];
    for(T bi = 1; bi < coeff[i][1]; bi++) {
      if(tmp*bi % coeff[i][1] == 1) {
        b[i] = bi % M;
        break;
      }
    }
  }

  for(decltype(S) i = 0; i < S; i++) {
    T tmp = coeff[i][0]*b[i] % M;
    tmp *= M/coeff[i][1];
    tmp %= M;
    ret += tmp;
    ret %= M;
  }
  return ret;
}

template<typename T, long unsigned int S>
constexpr T p15_int(const std::array<std::array<T, 2>, S> & coeff) {
  std::array<std::array<T, 2>, S> mydiscs = coeff;

  // fixup data to chinese remainder theorem compatible format
  for(decltype(S) i = 0; i < S; i++) {
    mydiscs[i][0] += (i+1);
    mydiscs[i][0] = -mydiscs[i][0];
    while(mydiscs[i][0] < 0) mydiscs[i][0] += mydiscs[i][1];
    mydiscs[i][0] %= mydiscs[i][1];
  }
  return chinese_remainder(mydiscs);
}

}

void p15() {
  std::cout << p15_int(discs1) << std::endl;
  std::cout << p15_int(discs2) << std::endl;
}

int main() {
  p15();
}
