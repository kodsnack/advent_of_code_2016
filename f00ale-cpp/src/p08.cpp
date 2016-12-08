#include <iostream>
#include <array>
#include <deque>
#include <unordered_map>
#include <string>

constexpr auto W = 50;
constexpr auto H = 6;

#include "p08_data.h"
#include "p08_chartable.h"

enum class State {
  Start, Id, Num
};

enum class TokenType {
  Rect, Num, X, Y, Rotate, Column, Row, By, Eq
};

std::unordered_map<std::string, TokenType> Identifiers {
  {"rect", TokenType::Rect},
  {"x", TokenType::X},
  {"y", TokenType::Y},
  {"rotate", TokenType::Rotate},
  {"column", TokenType::Column},
  {"row", TokenType::Row},
  {"by", TokenType::By}
};


struct Token {
  TokenType id;
  int data;
  constexpr Token(TokenType _id, int _data = 0) : id{_id}, data{_data} {}
};

#if 0
// debug stuff
std::ostream & operator<<(std::ostream & os, const TokenType & tt) {
  switch(tt) {
  case TokenType::Rect: os << "Rect"; break;
  case TokenType::Num: os << "Num"; break;
  case TokenType::X: os << "X"; break;
  case TokenType::Y: os << "Y"; break;
  case TokenType::Rotate: os << "Rotate"; break;
  case TokenType::Column: os << "Column"; break;
  case TokenType::Row: os << "Row"; break;
  case TokenType::By: os << "By"; break;
  case TokenType::Eq: os << "Eq"; break;
  }
  return os;
}

std::ostream & operator<<(std::ostream & os, const Token & tok) {
  os << tok.id;
  if(tok.id == TokenType::Num) os << " = " << tok.data;
  return os;
}

template<size_t h, size_t w>
void dump(const std::array<std::array<bool, w>, h> & aa) {
  for(const auto & a : aa) {
    for(auto b : a) {
      std::cout << (b?'#':'.');
    }
    std::cout << std::endl;
  }
}
#define LOG(x) do { std::cout << x << std::endl; } while(0)
#else
#define LOG(x)
#endif

std::deque<Token> tokenize(const char * data) {
  std::deque<Token> ret;
  int num = 0;
  std::string id;
  State state{State::Start};
  while(*data) {
    switch(state) {
    case State::Start:
      switch(*data) {
        case '0'...'9':
          num = *data-'0';
          state = State::Num;
          break;
        case 'a'...'z':
          id = *data;
          state = State::Id;
          break;
        case '=':
          ret.emplace_back(TokenType::Eq);
          break;
      }
      break;
    case State::Num:
      switch(*data) {
        case '0'...'9':
          num *= 10;
          num += (*data-'0');
          break;
        default:
          ret.emplace_back(TokenType::Num, num);
          num = 0;
          state = State::Start;
          continue;
      }
      break;
    case State::Id:
      switch(*data) {
        case 'a'...'z':
          id.push_back(*data);
          break;
        default:
          {
            auto it = Identifiers.find(id);
            if(it != Identifiers.end()) {
              ret.emplace_back(it->second);
            } else {
              LOG("Unexpeced identifier: " << id);
              exit(-1);
            }
            state = State::Start;
          }
          continue;
      }
      break;
    }
    data++;
  }

  return ret;
}

int main() {
  std::array<std::array<bool, W>,H> arr;
  std::deque<Token> tokens = tokenize(p08data);

  for(auto & a : arr) for(auto & b : a) b = false;

  while(!tokens.empty()) {
    switch(tokens.front().id) {
      case TokenType::Rect:
        tokens.pop_front();
        if(!tokens.empty() && tokens.front().id == TokenType::Num) {
          const int w = tokens.front().data;
          tokens.pop_front();
          if(!tokens.empty() && tokens.front().id == TokenType::X) {
            tokens.pop_front();
            if(!tokens.empty() && tokens.front().id == TokenType::Num) {
              const int h = tokens.front().data;
              tokens.pop_front();
              for(int y = 0; y < h; y++) for(int x = 0; x < w; x++) arr[y][x] = true;
            } else {
              LOG("expected number");
              return -1;
            }
          } else {
            LOG("expected x");
            return -1;
          }
        } else {
          LOG("expected num after rect");
          return -1;
        }
        break;
      case TokenType::Rotate:
        tokens.pop_front();
        if(tokens.empty()) {
          LOG("ran out of tokens after rotate!");
          return -1;
        }
        switch(tokens.front().id) {
          case TokenType::Row:
            tokens.pop_front();
            if(!tokens.empty() && tokens.front().id == TokenType::Y) {
              tokens.pop_front();
              if(!tokens.empty() && tokens.front().id == TokenType::Eq) {
                tokens.pop_front();
                if(!tokens.empty() && tokens.front().id == TokenType::Num) {
                  const int row = tokens.front().data;
                  tokens.pop_front();
                  if(!tokens.empty() && tokens.front().id == TokenType::By) {
                    tokens.pop_front();
                    if(!tokens.empty() && tokens.front().id == TokenType::Num) {
                      const int steps = tokens.front().data;
                      tokens.pop_front();
                      std::array<bool, W> tmp;
                      for(int c = 0; c<W; c++) tmp[(c+steps)%W] = arr[row][c];
                      for(int c = 0; c<W; c++) arr[row][c] = tmp[c];
                    } else {
                      LOG("expected num  after row y = num by");
                      return -1;
                    }
                  } else {
                    LOG("expected by after row y = num");
                    return -1;
                  }
                } else {
                  LOG("expected number after row y =");
                  return -1;
                }
              } else {
                LOG("expected = after row y");
                return -1;
              }
            } else {
              LOG("expected y after row");
              return -1;
            }
            break;
          case TokenType::Column:
            tokens.pop_front();
            if(!tokens.empty() && tokens.front().id == TokenType::X) {
              tokens.pop_front();
              if(!tokens.empty() && tokens.front().id == TokenType::Eq) {
                tokens.pop_front();
                if(!tokens.empty() && tokens.front().id == TokenType::Num) {
                  const int col = tokens.front().data;
                  tokens.pop_front();
                  if(!tokens.empty() && tokens.front().id == TokenType::By) {
                    tokens.pop_front();
                    if(!tokens.empty() && tokens.front().id == TokenType::Num) {
                      const int steps = tokens.front().data;
                      tokens.pop_front();
                      std::array<bool, H> tmp;
                      for(int r = 0; r<H; r++) tmp[(r+steps)%H] = arr[r][col];
                      for(int r = 0; r<H; r++) arr[r][col] = tmp[r];
                    } else {
                      LOG("expected by after column x = num by");
                      return -1;
                    }
                  } else {
                    LOG("expected by after column x = num");
                    return -1;
                  }
                } else {
                  LOG("expected number after column x =");
                  return -1;
                }
              } else {
                LOG("expected = after column x");
                return -1;
              }
            } else {
              LOG("expected x after column");
              return -1;
            }
            break;
          default:
            LOG("unexpected " << tokens.front() << " after rotate");
            return -1;
        }
        break;
      default:
        LOG("Expected rect or rotate, got " << tokens.front());
        return -1;
    }
  }

  int ans1 = 0;
  for(const auto & a : arr) for(auto b : a) if(b) ans1++;
  std::cout << ans1 << std::endl;

  // part 2
  std::string ans2;
  constexpr int CW = 5; //character width
  for(int offset = 0; offset < W; offset+=CW) {
    char found = 0;
    std::array<char, H> ch;
    for(int i=0; i < H; i++) ch[i] = 0;
    for(int r=0; r < H; r++) {
      for(int c=0; c<CW; c++) {
        ch[r] <<= 1;
        ch[r] |= (arr[r][offset+c] ? 1 : 0);
      }
    }
    for(auto & t : charbitmaps) {
      if(ch == std::get<1>(t)) {
	found = std::get<0>(t);
        break;
      }
    }
    if(!found) {
      std::cout << "Char " << (offset/5+1) << " not decoded." << std::endl;
      found = '.';
    }
    ans2.push_back(found);
  }
  std::cout << ans2 << std::endl;
  return 0;
}
