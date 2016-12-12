#include <iostream>
#include <vector>
#include <deque>
#include <string>
#include <unordered_map>
#include <array>

const char p12data[] = R"(
cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 14 c
cpy 14 d
inc a
dec d
jnz d -2
dec c
jnz c -5
)";

enum class TokenType {Cpy, Inc, Dec, Jnz, Num, Reg};
struct Token {
  TokenType type;
  int data;
  Token(TokenType t, int d) : type{t}, data{d} {}
};

std::unordered_map<std::string, TokenType> keywords {
  {"cpy", TokenType::Cpy},
  {"inc", TokenType::Inc},
  {"dec", TokenType::Dec},
  {"jnz", TokenType::Jnz}
};

std::ostream & operator<<(std::ostream & os, TokenType t) {
  switch(t) {
    case TokenType::Cpy: os << "Cpy"; break;
    case TokenType::Inc: os << "Inc"; break;
    case TokenType::Dec: os << "Dec"; break;
    case TokenType::Jnz: os << "Jnz"; break;
    case TokenType::Num: os << "Num"; break;
    case TokenType::Reg: os << "Reg"; break;
  }
  return os;
}

std::ostream & operator<<(std::ostream & os, const Token & t) {
  os << t.type;
  if(t.type == TokenType::Num || t.type == TokenType::Reg) os << " (" << t.data << ")";
  return os;
}

std::deque<Token> tokenize(const char *c) {
  std::deque<Token> ret;
  std::string id;
  int num = 0;
  bool innum = false;
  bool neg_num = false;
  while(*c) {
    switch(*c) {
      case 'a'...'z':
        id.push_back(*c);
        break;
      case '-':
        if(!innum && id.empty() && !neg_num) {
          neg_num = true;
        } else {
          std::cout << "unexpected -" << std::endl;
          return ret;
        }
        break;
      case '0'...'9':
        innum = true;
        num*=10;
        num+=(*c-'0');
        break;
      default:
        if(innum) {
          ret.emplace_back(TokenType::Num, (neg_num ? -1 : 1)*num);
        } else if(!id.empty()) {
          if(id.size() == 1) {
            if(id[0] >= 'a' && id[0] <= 'd') {
              ret.emplace_back(TokenType::Reg, id[0]-'a');
            } else {
              std::cout << "Unhandeled register " << id[0] << std::endl;
              return ret;
            }
          } else {
            auto it = keywords.find(id);
            if(it != end(keywords)) {
              ret.emplace_back(it->second, 0);
            } else {
              std::cout << "Unknown command " << id << std::endl;
              return ret;
            }
          }
        }
        num = 0;
        innum = false;
        neg_num = false;
        id.clear();
        break;
    }
    c++;
  }
  return ret;
}

enum class CmdType { Cpy, Inc, Dec, Jnz };
struct Command {
  CmdType type;
  int d1;
  bool r1;
  int d2;
  bool r2;
  Command(CmdType _t, int _d1, bool _r1, int _d2 = 0, bool _r2 = false) : type{_t}, d1{_d1}, r1{_r1}, d2{_d2}, r2{_r2} {}
};

std::ostream & operator<<(std::ostream & os, CmdType c) {
  switch(c) {
    case CmdType::Cpy: os << "cpy"; break;
    case CmdType::Inc: os << "inc"; break;
    case CmdType::Dec: os << "dec"; break;
    case CmdType::Jnz: os << "jnz"; break;
  }
  return os;
}

std::ostream & operator<<(std::ostream & os, const Command & cmd) {
  os << cmd.type;
  os << ' ';
  if(cmd.r1) os << (char)('a'+cmd.d1);
  else os << cmd.d1;

  if((cmd.type == CmdType::Cpy) || (cmd.type == CmdType::Jnz)) {
    os << ' ';
    if(cmd.r2) os << (char)('a'+cmd.d2);
    else os << cmd.d2;
  }
  return os;
}

int runprog(const std::vector<Command> & prog, std::array<int,4> & regs) {
  size_t pc = 0;
  int i = 0;
  while(pc < prog.size()) {
    i++;
    const auto & cmd = prog[pc];
    switch(cmd.type) {
      case CmdType::Cpy:
        if(cmd.r1) regs[cmd.d2] = regs[cmd.d1];
        else regs[cmd.d2] = cmd.d1;
        break;
      case CmdType::Inc:
        regs[cmd.d1]++;
        break;
      case CmdType::Dec:
        regs[cmd.d1]--;
        break;
      case CmdType::Jnz:
        if((cmd.r1 && regs[cmd.d1]) || (!cmd.r1 && cmd.d1)) {
          pc+=(cmd.r2 ? regs[cmd.d2] : cmd.d2);
          pc--; // pc is automatically increased by one at end of loop
        }
        break;
    }
    pc++;
  }
  return i;
}

std::vector<Command> compile(std::deque<Token> tokens) { //NB! token queue as value
  std::vector<Command> prog;
  while(!tokens.empty()) {
    switch(tokens.front().type) {
      case TokenType::Cpy:
        tokens.pop_front();
        if(tokens.empty()) {
          std::cout << "Expected number/register after cpy (empty)" << std::endl;
          return prog;
        } else {
	  int a1 = 0;
          bool t1 = false;
	  switch(tokens.front().type) {
            case TokenType::Num:
              a1 = tokens.front().data;
              t1 = false;
              break;
            case TokenType::Reg:
              a1 = tokens.front().data;
              t1 = true;
              break;
            default:
              std::cout << "Expected number/register after cpy" << std::endl;
              return prog;
          }
          tokens.pop_front();
          if(!tokens.empty() && tokens.front().type == TokenType::Reg) {
            prog.emplace_back(CmdType::Cpy, a1, t1, tokens.front().data, true);
            tokens.pop_front();
          } else {
            std::cout << "Expected register after cpy num/reg" << std::endl;
            return prog;
          }
        }
        break;
      case TokenType::Inc:
        tokens.pop_front();
        if(!tokens.empty() && tokens.front().type == TokenType::Reg) {
          prog.emplace_back(CmdType::Inc, tokens.front().data, true);
          tokens.pop_front();
        } else {
          std::cout << "Expected register after inc" << std::endl;
          return prog;
        }
        break;
      case TokenType::Dec:
        tokens.pop_front();
        if(!tokens.empty() && tokens.front().type == TokenType::Reg) {
          prog.emplace_back(CmdType::Dec, tokens.front().data, true);
          tokens.pop_front();
        } else {
          std::cout << "Expected register after dec" << std::endl;
          return prog;
        }
        break;
      case TokenType::Jnz:
        tokens.pop_front();
        if(!tokens.empty()) {
	  int a1 = 0;
          bool t1 = false;
	  switch(tokens.front().type) {
            case TokenType::Num:
              a1 = tokens.front().data;
              t1 = false;
              break;
            case TokenType::Reg:
              a1 = tokens.front().data;
              t1 = true;
              break;
            default:
              std::cout << "Expected number/register after jnz" << std::endl;
              return prog;
          }
          tokens.pop_front();
          if(!tokens.empty()) {
            switch(tokens.front().type) {
              case TokenType::Num:
                prog.emplace_back(CmdType::Jnz, a1, t1, tokens.front().data, false);
                break;
              case TokenType::Reg:
                prog.emplace_back(CmdType::Jnz, a1, t1, tokens.front().data, true);
                break;
              default:
                std::cout << "Expected number/register after jnz reg/num" << std::endl;
                return prog;
            }
            tokens.pop_front();
          } else {
            std::cout << "Expected number/register after jnz reg/num (empty)" << std::endl;
            return prog;
          }
        } else {
          std::cout << "Expected number/register after jnz (empty)" << std::endl;
          return prog;
        }
        break;
      default:
        std::cout << "Unexpected token " << tokens.front() << " " << tokens.size() << std::endl;
        return prog;
    }
  }
  return prog;
}

int p12_1(const std::vector<Command> & prog) {
  std::array<int, 4> regs{{0, 0, 0, 0}};
  runprog(prog, regs);
  return regs[0];
}

int p12_2(const std::vector<Command> & prog) {
  std::array<int, 4> regs{{0, 0, 1, 0}};
  runprog(prog, regs);
  return regs[0];
}

void p12() {
  auto prog = compile(tokenize(p12data));
  std::cout << p12_1(prog) << std::endl;
  std::cout << p12_2(prog) << std::endl;
}

int main() {
  p12();
  return 0;
}
