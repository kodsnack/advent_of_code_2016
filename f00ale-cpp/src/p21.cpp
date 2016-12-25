#include <iostream>
#include <unordered_map>
#include <string>
#include <deque>
#include <algorithm>

#include "p21_data.h"

namespace {

enum class TokenType {Rot, Swap, Move, Rev, Right, Left, Num, Letter, Ignore};
struct Token {
  TokenType type;
  std::string::size_type num;
  char ch;
  Token(TokenType t) : type{t}, num{0}, ch{0} {}
  Token(TokenType t, std::string::size_type d) : type{t}, num{d}, ch{0} {}
  Token(TokenType t, char c) : type{t}, num{0}, ch{c} {}
};

std::unordered_map<std::string, TokenType> keywords {
  {"rotate", TokenType::Rot},
  {"swap", TokenType::Swap},
  {"move", TokenType::Move},
  {"reverse", TokenType::Rev},
  {"right", TokenType::Right},
  {"left", TokenType::Left},
  {"steps", TokenType::Ignore},
  {"letter", TokenType::Ignore},
  {"with", TokenType::Ignore},
  {"position", TokenType::Ignore},
  {"to", TokenType::Ignore},
  {"on", TokenType::Ignore},
  {"based", TokenType::Ignore},
  {"steps", TokenType::Ignore},
  {"positions", TokenType::Ignore},
  {"through", TokenType::Ignore},
  {"of", TokenType::Ignore},
  {"step", TokenType::Ignore},
};

std::deque<Token> tokenize(const char *c) {
  std::deque<Token> ret;
  std::string id;
  std::string::size_type num = 0;
  bool innum = false;
  while(*c) {
    switch(*c) {
      case 'a'...'z':
        id.push_back(*c);
        break;
      case '0'...'9':
        innum = true;
        num*=10;
        num+=(*c-'0');
        break;
      default:
        if(innum) {
          ret.emplace_back(TokenType::Num, num);
        } else if(!id.empty()) {
          if(id.size() == 1) {
              ret.emplace_back(TokenType::Letter, id[0]);
          } else {
            auto it = keywords.find(id);
            if(it != end(keywords)) {
              if(it->second != TokenType::Ignore)
                ret.emplace_back(it->second);
            } else {
              std::cout << "Unknown command " << id << std::endl;
              return ret;
            }
          }
        }
        num = 0;
        innum = false;
        id.clear();
        break;
    }
    c++;
  }
  return ret;
}

std::string scramble(std::deque<Token> tks, std::string pw) {
  while(!tks.empty()) {
    switch(tks.front().type) {
      case TokenType::Swap:
        tks.pop_front();
        if(tks.empty()) {
          std::cout << "no token after swap" << std::endl;
          return "";
        }
        switch(tks.front().type) {
          case TokenType::Letter:
            {
              char c1 = tks.front().ch;
              tks.pop_front();
              if(tks.empty() || tks.front().type != TokenType::Letter) {
                std::cout << "expected letter after swap letter" << std::endl;
                return "";
              }
              char c2 = tks.front().ch;
              auto n1 = pw.find(c1);
              auto n2 = pw.find(c2);
              if(n1 == std::string::npos || n2 == std::string::npos) {
                std::cout << "char " << c1 << " or " << c2 << " not found in " << pw << std::endl;
                return "";
              }
              std::swap(pw[n1], pw[n2]);
            }
            break;
          case TokenType::Num:
            {
              auto n1 = tks.front().num;
              tks.pop_front();
              if(tks.empty() || tks.front().type != TokenType::Num) {
                std::cout << "expected number after swap number" << std::endl;
                return "";
              }
              auto n2 = tks.front().num;
              std::swap(pw[n1], pw[n2]);
            }
            break;
          default:
            std::cout << "Unexpected after swap" << std::endl;
            return "";
        }
        break;
      case TokenType::Rev:
        tks.pop_front();
        if(!tks.empty() && tks.front().type == TokenType::Num) {
          auto n1 = tks.front().num;
          tks.pop_front();
          if(!tks.empty() && tks.front().type == TokenType::Num) {
            auto n2 = tks.front().num;
            auto cpy = pw;
            for(auto i = n1; i <= n2; i++) {
              pw[n2-i+n1] = cpy[i];
            }
          } else {
            std::cout << "expected number after reverse number" << std::endl;
            return "";
          }
        } else {
          std::cout << "expected number after reverse" << std::endl;
          return "";
        }
        break;
      case TokenType::Rot:
        tks.pop_front();
        if(!tks.empty()) {
        bool right = false;
        int steps = 0;
        switch(tks.front().type) {
        case TokenType::Right:
        case TokenType::Left: // falltrough
          right = tks.front().type == TokenType::Right;
          tks.pop_front();
          if(!tks.empty() && tks.front().type == TokenType::Num) {
            steps = tks.front().num;
          } else {
            std::cout << "Expected num after rotate left/right" << std::endl;
            return "";
          }
          break;
        case TokenType::Letter:
          {
            right = true;
            auto idx = pw.find(tks.front().ch);
            if(idx == std::string::npos) {
            std::cout << "letter " << tks.front().ch << " not found in " << pw << " for rotate" << std::endl;
            return "";
            }
            steps = idx + (idx >= 4 ? 2 : 1);
          }
          break;
        default:
          std::cout << "Expected left, right or letter after rotate" << std::endl;
          return "";
        }
        if(right) {
          steps = pw.size()-steps;
          while(steps < 0) steps+=pw.size();
        }
        auto l = pw.substr(0, steps);
        auto r = pw.substr(steps);
        pw = r+l;

      } else {
        std::cout << "expected token after rotate" << std::endl;
        return "";
      }
      break;
      case TokenType::Move:
      tks.pop_front();
      if(!tks.empty() && tks.front().type == TokenType::Num) {
        auto from = tks.front().num;
        tks.pop_front();
        if(!tks.empty() && tks.front().type == TokenType::Num) {
          auto to = tks.front().num;
          auto c = pw[from];

          std::string cpy;
            for(std::string::size_type i = 0; i < pw.size(); i++) {
            if(i==from) continue;
            cpy.push_back(pw[i]);
          }
          pw.clear();
            for(std::string::size_type i = 0; i < cpy.size(); i++) {
            if(i==to) pw.push_back(c);
            pw.push_back(cpy[i]);
          }
          if(pw.size()==to) pw.push_back(c);
        } else {
          std::cout << "Expected num after move num" << std::endl;
          return "";
        }
      } else {
        std::cout << "Expected num after move" << std::endl;
        return "";
      }
      break;
      default:
        std::cout << "Unexpected (top level)" << std::endl;
        return "";
    }
    tks.pop_front();
  }
  return pw;
}

} // anon namespace

void p21() {
  auto tks = tokenize(p21data);
  std::string pw{"abcdefgh"};
  std::cout << scramble(tks, pw) << std::endl;

  do {
    auto sc = scramble(tks, pw);
    if(sc == "fbgdceah") {
      std::cout << pw << std::endl;
      break;
    }
  } while(std::next_permutation(begin(pw), end(pw)));
}

int main() {
  p21();
}
