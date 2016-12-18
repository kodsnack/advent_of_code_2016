#include <iostream>
#include <string>

#include "../src/md5_util.h"

void test(int len, const std::string & bl) {
  std::string s;
  for(int i = 0; i < len; i++) {
    s.push_back('0'+(i%10));
  }
  auto md = md5::md5(s.c_str(), s.length());
  std::cout << len << ": ";
  auto ms = md5::tochars(md);
  bool ok = true;
  for(int i = 0; i < 32; i++) ok = ok && (ms[i] == bl[i]);
  std::cout << (ok ? "OK" : "FAIL") << " ";
  for(auto c : ms) std::cout << c;
  std::cout << " " << s << std::endl;
}

int main() {
  test(53, "a3360e2d7e28ed4572c3dc16ef705372");
  test(54, "3dff83c8fadd26370d5b098409644457");
  test(55, "6e7a4fc92eb1c3f6e652425bcc8d44b5");

  test(63, "c5e256437e758092dbfe06283e489019");
  test(64, "7f7bfd348709deeaace19e3f535f8c54");
  test(65, "beb9f48bc802ca5ca043bcc15e219a5a");

  test(66, "d6329b22b4b67da8120d0074eb28cb31");
}
