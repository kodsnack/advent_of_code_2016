#include <iostream>

#include "p09_data.h"

int decompresslen(const char * c) {
  int ret = 0, num = 0, mul = 0;
  enum class State { Scan, InParen1, InParen2, InData };
  State state{State::Scan};
  while(*c) {
    switch(state) {
    case State::Scan:
      switch(*c) {
        case 'A'...'Z':
          ret++;
          break;
        case '(':
          num = 0;
          state = State::InParen1;
          break;
        case ' ':
        case '\n':
          break;
        default:
          std::cout << "Unexpected char ";
          if(*c > 0x20) std::cout << *c << std::endl;
          else std::cout << std::hex << "0x" << (int)*c << std::dec << std::endl;
          break;
      }
      break;
    case State::InParen1:
      switch(*c) {
      case '0'...'9':
        num *= 10;
        num += (*c-'0');
        break;
      case 'x':
        state = State::InParen2;
        break;
      default:
        std::cout << "Unexpected char in InParen1" << std::endl;
      }
      break;
    case State::InParen2:
      switch(*c) {
      case '0'...'9':
        mul *= 10;
        mul += (*c-'0');
        break;
      case ')':
        ret += num*mul;
        state = State::InData;
        break;
      default:
        std::cout << "Unexpected char in InParen2" << std::endl;
      }
      break;
    case State::InData:
      switch(*c) {
      case ' ':
      case '\n':
        //ignore whitespace
        break;
      default:
        if(!--num) {
          state = State::Scan;
          num = mul = 0;
        }
        break;
      }
      break;
    }
    c++;
  }
  return ret;
}

void test(const char *data, int expected) {
  auto l = decompresslen(data);
  if(l!=expected) {
    std::cout << "Test fail for " << data << ". Expected " << expected << ", got " << l << std::endl;
  }
}

int main() {
  test("ADVENT", 6);
  test("A(1x5)BC", 7);
  test("(3x3)XYZ", 9);
  test("A(2x2)BCD(2x2)EFG", 11);
  test("(6x1)(1x3)A", 6);
  test("X(8x2)(3x3)ABCY", 18);

  std::cout << decompresslen(p09data) << std::endl;
}
