#include "aoc-main.h"
#include "vector.h"
#include "hashmap.h"

#include <stdio.h>

enum OpCode {
  cpy,
  inc,
  dec,
  jnz,
  out
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
    case 'o':
      return out;
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

int run(Vector v, int *r, int *ip){
  int size = Vector_size(v);
  struct Inst *instrs = Vector_data(v);
  int i;
  for(i = *ip; i < size; ++i){
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
      case out:
        *ip = i+1;
        return to_value(r, inst->x);
      default:
        printf("Error bad instruction\n");
    }
  }
  *ip = -1;
  return -1;
}

struct State {
  int ip;
  int r[4];
};

unsigned int state_hash(const void *p){
  const struct State *s = p;
  unsigned int hash = HM_integer_hash(s->ip);
  for(int i = 0; i < 4; ++i){
    hash += HM_integer_hash(s->r[i]);
  }
  return hash;
}

int state_equal(const void *a, const void *b){
  const struct State *lhs = a;
  const struct State *rhs = b;
  if(lhs->ip != rhs->ip) return 0;
  for(int i = 0; i < 4; ++i){
    if(lhs->r[i] != rhs->r[i]) return 0;
  }
  return 1;
}

int check_state(HashMap h, struct State s){
  if(HM_find(h, &s)) return 1;
  struct State *p = malloc(sizeof(struct State));
  *p = s;
  HM_set_insert(h, p);
  return 0;
}

void part1(){
  Vector v = read_input();
  for(int a = 0;; ++a){
    HashMap h = HM_create(state_hash, state_equal, free, NULL);
    struct State state = {0, {a, 0, 0, 0}};
    int last_output = -1;
    int loop_found;
    last_output = run(v, state.r, &state.ip);
    while(!(loop_found = check_state(h, state))){
      int output = run(v, state.r, &state.ip);
      if((last_output == 1 && output == 0) || (last_output == 0 && output == 1));
      else break;
      last_output = output;
    }
    HM_destroy(&h);
    if(loop_found){
      printf("%d\n", a);
      break;
    }
  }

  Vector_free(v);
}
void part2(){
  printf("Merry Christmas!\n");
}
