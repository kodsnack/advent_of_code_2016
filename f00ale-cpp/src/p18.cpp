#include <iostream>
#include <string>

int p18_int(const int ROWS) {
  std::string data = "^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^";
  std::string nd = data;
  int row = 0;
  int ant = 0;
  do {
    for(auto c : data) if(c == '.') ant++;
    for(size_t col = 0; col < data.size(); col++) {
      bool l = (col==0) ? (false) : (data[col-1] == '^');
      bool c = data[col] == '^';
      bool r = (col+1==data.size()) ? (false) : (data[col+1] == '^');
      bool t = (l&&c&&!r) || (!l&&c&&r) || (l&&!c&&!r) || (!l&&!c&&r);
      nd[col] = (t ? '^' : '.');
    }
    data.swap(nd);
  } while(++row < ROWS);
  return ant;
}


void p18() {
  std::cout << p18_int(40) << std::endl;
  std::cout << p18_int(400000) << std::endl;
}

int main() {
  p18();
}
