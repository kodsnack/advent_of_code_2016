#include <iostream>
#include "pystrlib.hpp"

#define CPY 1
#define INC 2
#define DEC 3
#define JNZ 4

int reg[4];

struct Operand {
    int type, value;
    Operand() {}
    Operand(const std::string &v) {
        if (std::isdigit(v[0]) || v[0] == '-') type = 0, value = std::stoi(v);
        else type = 1, value = v[0] - 'a';
    }
    operator int () const { return type ? reg[value] : value; }
    int operator=(int v) const { return type ? (reg[value] = v) : value; }
};

int code[50], n, pt;
Operand op1[50], op2[50];

int main() {
    freopen("day12.txt", "r", stdin);
    {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::string> v = lib::split(line, " ");
            if (v[0] == "cpy") code[n] = CPY, op1[n] = Operand(v[1]), op2[n] = Operand(v[2]);
            else if (v[0] == "inc") code[n] = INC, op1[n] = Operand(v[1]);
            else if (v[0] == "dec") code[n] = DEC, op1[n] = Operand(v[1]);
            else if (v[0] == "jnz") code[n] = JNZ, op1[n] = Operand(v[1]), op2[n] = Operand(v[2]);
            ++n;
        }
    }
    while (pt < n) {
        switch (code[pt]) {
            case CPY: op2[pt] = (int) op1[pt]; ++pt; break;
            case INC: op1[pt] = op1[pt] + 1; ++pt; break;
            case DEC: op1[pt] = op1[pt] - 1; ++pt; break;
            case JNZ: if ((int) op1[pt]) pt += op2[pt]; else ++pt; break;
        }
    }
    std::cout << reg[0] << std::endl;
    return 0;
}