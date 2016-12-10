#include <iostream>
#include <stdint.h>

#include "p09_data.h"

int64_t decompressleni(const char * c, int len) {
  int64_t ret = 0;
  int num = 0, mul = 0;
  enum class State { Scan, InParen1, InParen2, InData };
  State state{State::Scan};
  while(*c && len) {
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
          if(*c > 0x20) std::cout << *c;
          else std::cout << std::hex << "0x" << (int)*c << std::dec;
          std::cout << " in Scan." << std::endl;
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
        std::cout << "Unexpected char " << *c << " in InParen1" << std::endl;
      }
      break;
    case State::InParen2:
      switch(*c) {
      case '0'...'9':
        mul *= 10;
        mul += (*c-'0');
        break;
      case ')':
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
        ret += mul*decompressleni(c, num);
        len -= num;
        c+=num;
        state = State::Scan;
        num = mul = 0;
        continue;
      }
      break;
    }
    c++;
    len--;
  }
  return ret;
}

int64_t decompresslen(const char * c) {
  int len = 0;
  const char *d = c;
  while(*d++) len++;
  return decompressleni(c, len);
}

void test(const char *data, int64_t expected) {
  auto l = decompresslen(data);
  if(l!=expected) {
    std::cout << "Test fail for " << data << ". Expected " << expected << ", got " << l << std::endl;
  }
}

int main() {
  test("(1x2)A", 2);
  test("(1x2)AB", 3);
  test("(6x1)(1x1)A", 1);
  test("(6x2)(1x1)A", 2);
  test("(6x2)(1x2)A", 4);
  test("(6x2)(1x2)AB", 5);
  test("ADVENT", 6);
  test("A(1x5)BC", 7);
  test("(3x3)XYZ", 9);
  test("X(8x2)(3x3)ABCY", 20);
  test("(27x12)(20x12)(13x14)(7x10)(1x12)A", 241920);
  test("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN", 445);
  std::cout << decompresslen(p09data) << std::endl;
}
