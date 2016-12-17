#include <iostream>
#include <string>
#include <array>
#include <vector>

#include "md5_util.h"

std::array<char, 32> do_hash(const char * data, const unsigned int len, int extra) {
  std::array<char, 32> ret = md5::tochars(md5::md5(data, len));
  while(extra--) {
    ret = md5::tochars(md5::md5(ret.data(), ret.size()));
  }
  return ret;
}

unsigned int p14_int(const std::string & input, const int rounds) {
  int found = 0;
  unsigned int index = 0;
  std::vector<std::array<char, 32>> cache;
  while(found < 64) {
    while(cache.size() < (index+1000)) {
      auto data = input + std::to_string(cache.size());
      cache.emplace_back(do_hash(data.c_str(), data.length(), rounds));
    }

    const auto & str = cache[index];

    for(int i = 0; i < 32-2; i++) {
      if(str[i] == str[i+1] && str[i] == str[i+2]) {
        char c = str[i];
        bool f = false;
        for(int j = 1; j <= 1000; j++) {
          const auto & str2 = cache[index+j];
          for(int k = 0; k < 32-4; k++) {
            if(str2[k] != c) continue;
            if(c == str2[k+1] && c == str2[k+2] && c == str2[k+3] && c == str2[k+4]) {
              found++;
              f = true;
              break;
            }
          }
          if(f) break;
        }
        break;
      }
    }

    index++;
  }
  return index-1; // subtract last increase
}

int main() {
  static const std::string mdata = "qzyelonm";
  std::cout << p14_int(mdata, 0) << std::endl;
  std::cout << p14_int(mdata, 2016) << std::endl;
}
