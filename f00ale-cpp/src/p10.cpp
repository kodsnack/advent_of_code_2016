#include <iostream>
#include <array>
#include <deque>
#include <unordered_map>
#include <string>

#include "p10_data.h"

// it feels like 90% of the solution is parsing the data... :(
// I might need to change tactics on that...

enum class TokenType {
  Value, Num, Bot, Low, High, Output, Ignore // dummy token to ignore goes, to, gives, and
};

// for debug
std::ostream & operator<<(std::ostream & os, TokenType tt) {
  switch(tt) {
    case TokenType::Value: os << "Value"; break;
    case TokenType::Num: os << "Num"; break;
    case TokenType::Bot: os << "Bot"; break;
    case TokenType::Low: os << "Low"; break;
    case TokenType::High: os << "High"; break;
    case TokenType::Output: os << "Output"; break;
    case TokenType::Ignore: os << "Ignore"; break;
  }
  return os;
}

static const std::unordered_map<std::string, TokenType> tokenmap {
  {"value", TokenType::Value},
  {"bot", TokenType::Bot},
  {"low", TokenType::Low},
  {"high", TokenType::High},
  {"output", TokenType::Output},
  {"goes", TokenType::Ignore},
  {"to", TokenType::Ignore},
  {"gives", TokenType::Ignore},
  {"and", TokenType::Ignore},
};

struct Token {
  TokenType type;
  int data;
  Token(TokenType _t, int _d) : type{_t}, data{_d} {}
};

std::deque<Token> tokenize(const char *c) {
  std::deque<Token> ret;
  bool innum = false; // simple state :)
  int num = 0;
  std::string id;
  while(*c) {
    switch(*c) {
      case 'a'...'z':
        id.push_back(*c);
        break;
      case '0'...'9':
        innum = true;
        num *= 10;
        num += (*c-'0');
        break;
      default:
        if(innum) {
          ret.emplace_back(TokenType::Num, num);
          num = 0;
          innum = false;
        } else if(!id.empty()) {
          auto it = tokenmap.find(id);
          if(it != tokenmap.end()) {
            if(it->second != TokenType::Ignore) {
              ret.emplace_back(it->second, 0);
            }
          } else {
            std::cout << "token " << id << " not understood!" << std::endl;
            return ret; 
          }
          id.clear();
        }
      break;
    }
    c++;
  }
  return ret;
}

struct bot {
  int seen;
  int value1;
  int value2;
  int lowout; // outputs coded as output number + 1000
  int highout;
};

bool setValue(bot & b, int v) {
  b.seen = 1;
  if(b.value1 == v || b.value2 == v) return false; // dont store the same number twice
  if(b.value1 == -1) b.value1 = v;
  else if(b.value2 == -1) b.value2 = v;
  else std::cout << "Broken" << std::endl;
  if(b.value2 < b.value1) std::swap(b.value1, b.value2);
  return true;
}

int main() {
  std::array<bot, 256> bots;
  std::array<int, 256> outputs;
  for(auto & b : bots) { b = {0, -1, -1, -1, -1}; }
  for(auto & o : outputs) { o = -1; }

  auto tokens = tokenize(p10data);
  while(!tokens.empty()) {
    switch(tokens.front().type) {
    case TokenType::Value:
      tokens.pop_front();
      if(!tokens.empty() && tokens.front().type == TokenType::Num) {
        const int value = tokens.front().data;
        tokens.pop_front();
        if(!tokens.empty() && tokens.front().type == TokenType::Bot) {
          tokens.pop_front();
          if(!tokens.empty() && tokens.front().type == TokenType::Num) {
            const int botnum = tokens.front().data;
            tokens.pop_front();
            setValue(bots[botnum], value);
          } else {
            std::cout << "expected number after value number bot" << std::endl;
            return -1;
          }
        } else {
          std::cout << "expected bot after value number" << std::endl;
          return -1;
        }
      } else {
        std::cout << "expected number after value" << std::endl;
        return -1;
      }
      break;
    case TokenType::Bot:
      tokens.pop_front();
      if(!tokens.empty() && tokens.front().type == TokenType::Num) {
        const int bot = tokens.front().data;
        bots[bot].seen = 1;
        tokens.pop_front();
        if(!tokens.empty() && tokens.front().type == TokenType::Low) {
          tokens.pop_front();
          bool isOutput = false;
          if(!tokens.empty() && tokens.front().type == TokenType::Bot) {
            tokens.pop_front();
            isOutput = false;
          } else if(!tokens.empty() && tokens.front().type == TokenType::Output) {
            tokens.pop_front();
            isOutput = true;
          } else {
            std::cout << "expected bot or output after bot number low" << std::endl;
            return -1;
          }
          // 
          if(!tokens.empty() && tokens.front().type == TokenType::Num) {
            const int lowtarget = tokens.front().data + (isOutput ? 1000 : 0);
            bots[bot].lowout = lowtarget;
            tokens.pop_front();
          } else {
            std::cout << "expected number after bot number low" << std::endl;
            return -1;
          }
        } else {
          std::cout << "expected low after bot number" << std::endl;
          return -1;
        }
        //
        if(!tokens.empty() && tokens.front().type == TokenType::High) {
          tokens.pop_front();
          bool isOutput = false;
          if(!tokens.empty() && tokens.front().type == TokenType::Bot) {
            tokens.pop_front();
            isOutput = false;
          } else if(!tokens.empty() && tokens.front().type == TokenType::Output) {
            tokens.pop_front();
            isOutput = true;
          } else {
            std::cout << "expected bot or output after bot number low number high" << std::endl;
            return -1;
          }
          // 
          if(!tokens.empty() && tokens.front().type == TokenType::Num) {
            const int hightarget = tokens.front().data + (isOutput ? 1000 : 0);
            bots[bot].highout = hightarget;
            tokens.pop_front();
          } else {
            std::cout << "expected number after bot number low bot/output number high" << std::endl;
            return -1;
          }
        } else {
          std::cout << "expected high after bot number low bot/output number" << std::endl;
          return -1;
        }

      } else {
        std::cout << "expected number after bot" << std::endl;
        return -1;
      }
      break;
    default:
      std::cout << "expected value or bot, got " << tokens.front().type << std::endl;
      tokens.pop_front();
      break;
    }
  }

  // ok here is the actual algorithm

  bool changed = false;
  do {
    changed = false;
    for(auto & b : bots) {
      if(b.value1 != -1 && b.value2 != -1) {
        if(b.lowout < 1000) changed |= setValue(bots[b.lowout], b.value1);
        else outputs[b.lowout-1000] = b.value1;
        if(b.highout < 1000) changed |= setValue(bots[b.highout], b.value2);
        else outputs[b.highout-1000] = b.value2;
      }
    }
  } while(changed);

  for(size_t i = 0; i < bots.size(); i++) {
    auto & b = bots[i];
    if(b.value1 == 17 && b.value2 == 61) {
      std::cout << i << std::endl;
      break;
    }
  }

  std::cout << (outputs[0]*outputs[1]*outputs[2]) << std::endl; 
  return 0;
}