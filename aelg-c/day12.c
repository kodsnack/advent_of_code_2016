#include "aoc-main.h"
#include "vector.h"

#include <stdio.h>

enum OpCode {
  cpy,
  inc,
  dec,
  jnz
};

struct Value{
  int is_register;
  int x;
};

struct Inst {
  enum OpCode op_code;
  struct Value x;
  struct Value y;
};

static struct Value read_value(char *s){
  struct Value v;
  if(s[0] >= 'a' && s[0] <= 'd'){
    v.is_register = 1;
    v.x = s[0] - 'a';
  }
  else{
    v.is_register = 0;
    v.x = atoi(s);
  }
  return v;
}

static enum OpCode read_opcode(char *s){
  switch(s[0]){
    case 'c':
      return cpy;
    case 'i':
      return inc;
    case 'd':
      return dec;
    case 'j':
      return jnz;
  }
  fprintf(stderr, "Error bad opcode!\n");
  return -1;
}

static int read_line(Vector v){
  char op[4];
  char s[10];
  struct Inst inst;
  int res = scanf("%s %s", op, s);
  if(res == EOF) return 0;
  inst.op_code = read_opcode(op);
  inst.x = read_value(s);
  if(inst.op_code == cpy || inst.op_code == jnz){
    scanf("%s", s);
    inst.y = read_value(s);
  }
  Vector_push(v, &inst);
  return 1;
}

Vector read_input(){
  Vector v = Vector_create(sizeof(struct Inst));
  while(read_line(v));
  return v;
}

static int to_value(int *r, struct Value v){
  return v.is_register ? r[v.x] : v.x;
}

void run(Vector v, int *r){
  int size = Vector_size(v);
  struct Inst *instrs = Vector_data(v);
  for(int i = 0;i < size; ++i){
    struct Inst *inst = &instrs[i];
    switch(inst->op_code){
      case cpy:
        r[inst->y.x] = to_value(r, inst->x);
        break;
      case inc:
        ++r[inst->x.x];
        break;
      case dec:
        --r[inst->x.x];
        break;
      case jnz:
        if (to_value(r, inst->x)) i += to_value(r, inst->y)-1;
        break;
      default:
        printf("Error bad instruction\n");
    }
  }
}

void part1(){
  int r[4] = {0};
  Vector v = read_input();
  run(v, r);
  printf("%d\n", r['a' - 'a']);
  Vector_free(v);
}
void part2(){
  int r[4] = {0, 0, 1, 0};
  Vector v = read_input();
  run(v, r);
  printf("%d\n", r['a' - 'a']);
  Vector_free(v);
}
