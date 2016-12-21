#include <iostream>
#include <iomanip>
#include <array>
#include <tuple>
#include <set>
#include <deque>

#include "quick.h"

/*
  you can move
   - one or two generators
   - a single chip
   - two generators
   - two chips
   - a matching chip and generator

   - a generator cannot be on the same level as an unmatched chip
   - only one unmatched generator per floor

  we're done when everything is on the 4th floor
*/

/*
real data:
The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
The third floor contains a thulium-compatible microchip.
The fourth floor contains nothing relevant.
strontium = 0b00001
plutonium = 0b00010
thulium   = 0b00100
ruthenium = 0b01000
curium    = 0b10000
*/
using fstate = std::array<std::array<char, 2>, 4>;

constexpr fstate p11_1_data {{
  {{0b00011, 0b00011}}, // floor 1
  {{0b11000, 0b11100}}, // floor 2
  {{0b00100, 0b00000}}, // floor 3
  {{0b00000, 0b00000}}  // floor 4 
}};

constexpr fstate p11_2_data {{
  {{0b1100011, 0b1100011}}, // floor 1
  {{0b0011000, 0b0011100}}, // floor 2
  {{0b0000100, 0b0000000}}, // floor 3
  {{0b0000000, 0b0000000}}  // floor 4 
}};

using state = std::tuple<int, fstate>;

template<typename T>
inline T highest_set_bit(T in) {
  if(!in) return 0;
  T r = 0;
  while(in >>=1) {
    r++;
  } 
  return 1<<r;
}

bool isValid(const state & s) {
  auto & ar = std::get<1>(s);
  for(int i = 0; i < 4; i++) {
    auto chips = ar[i][0];
    auto gens  = ar[i][1];
    auto matched = chips & gens;
    chips ^= matched;
    gens ^= matched;
    if(gens && chips) return false;
  }
  return true;
}

int p11_int(const fstate & data) {
  std::deque<std::tuple<int, state>> queue;
  std::set<state> checked;
  auto start = std::make_tuple(0, data);
  queue.emplace_back(0, start);
  checked.insert(start);
  int ans = 0;

  bool final_state_found = false;
  while(!final_state_found && !queue.empty()) {
    const auto r = std::get<0>(queue.front());
    const auto & st = std::get<1>(queue.front());
    const auto fl = std::get<0>(st);
    const auto & ar = std::get<1>(st);

    if((fl == 3) && (0 == ar[0][0]) && (0 == ar[0][1]) && (0 == ar[1][0]) && (0 == ar[1][1]) && (0 == ar[2][0]) && (0 == ar[2][1])) {
      final_state_found = true;
      ans = r;
      break;
    }

    // first check pairs to move
    for(int s = 1; s <= highest_set_bit(ar[fl][1]); s <<= 1) {
      if((ar[fl][0] & s) && (ar[fl][1] & s)) {
        for(int d=-1; d < 2; d+=2) {
          if(fl+d < 0 || fl+d > 3) continue;
          auto narr = ar;
          narr[fl+d][0] |= s;
          narr[fl][0] ^= s;
          narr[fl+d][1] |= s;
          narr[fl][1] ^= s;
          auto nstate = make_tuple(fl+d, narr);
          if(checked.find(nstate) != end(checked)) continue;
          checked.insert(nstate);
          queue.push_back(make_tuple(r+1, nstate));
        }
      }
    }

    // check chip move
    auto const highchip = highest_set_bit(ar[fl][0]);
    for(int s1 = 1; s1 <= highchip; s1 <<= 1) {
      for(int s2 = s1; s2 <= highchip; s2 <<= 1) {
        auto s = s1 | s2;
        if((ar[fl][0] & s) == s) {
          for(int d=-1; d<2; d+=2) {
            if(fl+d < 0 || fl+d > 3) continue;
            auto narr = ar;
            narr[fl+d][0] |= s;
            narr[fl][0] ^= s;
            auto nstate = make_tuple(fl+d, narr);
            if(!isValid(nstate)) continue;
            if(checked.find(nstate) != end(checked)) continue;
            checked.insert(nstate);
            queue.push_back(make_tuple(r+1, nstate));
          }
        }
      }
    }

    // check generator move
    auto const highgen = highest_set_bit(ar[fl][1]);
    for(int s1 = 1; s1 <= highgen; s1 <<= 1) {
      for(int s2 = s1; s2 <= highgen; s2 <<= 1) {
        auto s = s1 | s2;
        if((ar[fl][1] & s) == s) {
          for(int d=-1; d<2; d+=2) {
            if(fl+d < 0 || fl+d > 3) continue;
            auto narr = ar;
            narr[fl+d][1] |= s;
            narr[fl][1] ^= s;
            auto nstate = make_tuple(fl+d, narr);
            if(!isValid(nstate)) continue;
            if(checked.find(nstate) != end(checked)) continue;
            checked.insert(nstate);
            queue.push_back(make_tuple(r+1, nstate));
          }
        }
      }
    }

    queue.pop_front();
  }
  return ans;
}

int main() {
  if(!quick) {
    std::cout << p11_int(p11_1_data) << std::endl;
    std::cout << p11_int(p11_2_data) << std::endl;
  } else {
    std::cout << 37 << std::endl;
    std::cout << 61 << std::endl;
  }
  return 0;
}
