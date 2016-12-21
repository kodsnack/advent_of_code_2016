#include <iostream>
#include <string>
#include <algorithm>

std::string p16_int(std::string data, const size_t len) {
  while(data.length() < len) {
    auto b = data;
    data.push_back('0');
    for(auto it = rbegin(b); it != rend(b); it++) {
      data.push_back(*it == '1' ? '0' : '1');
    }
  }

  data = data.substr(0, len);
  do {
    std::string chksum;
    for(size_t i = 0; i <= data.length()-1; i+=2) {
      if(data[i]==data[i+1]) chksum.push_back('1');
      else chksum.push_back('0');
    }
    data = chksum;
  } while(!(data.length() & 1) && data.length() > 0); 

  return data;
}


void p16() {
  std::cout << p16_int("10111011111001111", 272) << std::endl;
  std::cout << p16_int("10111011111001111", 35651584) << std::endl;
}

int main() {
  p16();
}
