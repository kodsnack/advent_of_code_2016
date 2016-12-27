#include <iostream>
#include <vector>
#include <deque>
#include <string>
#include <unordered_map>
#include <array>

const char p25data[] = R"(
cpy a d
cpy 7 c
cpy 365 b
inc d
dec b
jnz b -2
dec c
jnz c -5
cpy d a
jnz 0 0
cpy a b
cpy 0 a
cpy 2 c
jnz b 2
jnz 1 6
dec b
dec c
jnz c -4
inc a
jnz 1 -7
cpy 2 b
jnz c 2
jnz 1 4
dec b
dec c
jnz 1 -4
jnz 0 0
out b
jnz a -19
jnz 1 -21
)";

enum class TokenType {Cpy, Inc, Dec, Jnz, Num, Reg, Tgl, Out};
struct Token {
  TokenType type;
  int data;
  Token(TokenType t, int d) : type{t}, data{d} {}
};

std::unordered_map<std::string, TokenType> keywords {
  {"cpy", TokenType::Cpy},
  {"inc", TokenType::Inc},
  {"dec", TokenType::Dec},
  {"jnz", TokenType::Jnz},
  {"tgl", TokenType::Tgl},
  {"out", TokenType::Out}
};

std::ostream & operator<<(std::ostream & os, TokenType t) {
  switch(t) {
    case TokenType::Cpy: os << "Cpy"; break;
    case TokenType::Inc: os << "Inc"; break;
    case TokenType::Dec: os << "Dec"; break;
    case TokenType::Jnz: os << "Jnz"; break;
    case TokenType::Num: os << "Num"; break;
    case TokenType::Reg: os << "Reg"; break;
    case TokenType::Tgl: os << "Tgl"; break;
    case TokenType::Out: os << "Out"; break;
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

enum class CmdType { Cpy, Inc, Dec, Jnz, Tgl, Out };
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
    case CmdType::Tgl: os << "tgl"; break;
    case CmdType::Out: os << "out"; break;
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

int runprog(std::vector<Command> prog, std::array<int,4> & regs) {
  size_t pc = 0;
  int i = 0;
  int pat = 0;
  int count = 0;
  while(pc < prog.size()) {
    i++;
    const auto & cmd = prog[pc];
    switch(cmd.type) {
      case CmdType::Cpy:
        if(!cmd.r2) {}
        else if(cmd.r1) regs[cmd.d2] = regs[cmd.d1];
        else regs[cmd.d2] = cmd.d1;
        break;
      case CmdType::Inc:
        if(cmd.r1) regs[cmd.d1]++;
        break;
      case CmdType::Dec:
        if(cmd.r1) regs[cmd.d1]--;
        break;
      case CmdType::Jnz:
        if((cmd.r1 && regs[cmd.d1]) || (!cmd.r1 && cmd.d1)) {
          pc+=(cmd.r2 ? regs[cmd.d2] : cmd.d2);
          pc--; // pc is automatically increased by one at end of loop
        }
        break;
      case CmdType::Tgl:
        {
          size_t tpc = pc + (cmd.r1 ? regs[cmd.d1] : cmd.d1);
          if(tpc < prog.size()) {
            switch(prog[tpc].type) {
              case CmdType::Inc: prog[tpc].type = CmdType::Dec; break;
              case CmdType::Dec: prog[tpc].type = CmdType::Inc; break;
              case CmdType::Jnz: prog[tpc].type = CmdType::Cpy; break;
              case CmdType::Cpy: prog[tpc].type = CmdType::Jnz; break;
              case CmdType::Tgl: prog[tpc].type = CmdType::Inc; break;
              case CmdType::Out: prog[tpc].type = CmdType::Inc; break;
            }
          }
        }
        break;
      case CmdType::Out:
        {
          int val = cmd.r1 ? regs[cmd.d1] : cmd.d1;
          if(val == pat) {
            count++;
            if(count > 100) return 1;
            pat = (pat+1)&1;
          } else {
            return 0;
          }
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
      case TokenType::Tgl:
        tokens.pop_front();
        if(tokens.empty()) {
          std::cout << "Expected number/register after tgl (empty)" << std::endl;
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
              std::cout << "Expected number/register after tgl" << std::endl;
              return prog;
          }
          tokens.pop_front();
          prog.emplace_back(CmdType::Tgl, a1, t1);
        }
        break;
      case TokenType::Out:
        tokens.pop_front();
        if(tokens.empty()) {
          std::cout << "Expected number/register after out (empty)" << std::endl;
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
              std::cout << "Expected number/register after out" << std::endl;
              return prog;
          }
          tokens.pop_front();
          prog.emplace_back(CmdType::Out, a1, t1);
        }
        break;
      default:
        std::cout << "Unexpected token " << tokens.front() << " " << tokens.size() << std::endl;
        return prog;
    }
  }
  return prog;
}

int p25_1(const std::vector<Command> & prog) {
  int rega = 0;
  bool found = false;
  do {
    std::array<int, 4> regs{{++rega, 0, 0, 0}};
    found = runprog(prog, regs);
  } while(!found);
  return rega;
}

int p25_2(const std::vector<Command> & prog, int rega) {
  std::array<int, 4> regs{{rega, 0, 0, 0}};
  runprog(prog, regs);
  return regs[0];
}

void p25() {
  auto prog = compile(tokenize(p25data));
  std::cout << p25_1(prog) << std::endl;
  //std::cout << p25_2(prog, 12) << std::endl;
}

int main() {
  p25();
  return 0;
}
