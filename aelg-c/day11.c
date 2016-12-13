#include "aoc-main.h"
#include "vector.h"
#include "hashmap.h"

#include <stdio.h>
#include <regex.h>
#include <string.h>

static int N_ITEMS = 0;

static int get_floor(int state, int n){
  return (state >> (n*2)) & 3;
}

static int g_floor(int state, int n){
  return get_floor(state, n);
}

static int c_floor(int state, int n){
  return get_floor(state, n + N_ITEMS);
}

static int e_floor(int state){
  return get_floor(state, N_ITEMS*2);
}

static int is_paired(int state, int n){
  return g_floor(state, n) == c_floor(state, n);
}

static int update_state(int state, int n, int new_val){
  unsigned int mask = ~(3 << 2*n);
  return (state & mask) | (new_val) << 2*n;
}

static int is_legal(int state){
  int floors_with_generator = 0;
  for(int i = 0; i < N_ITEMS; ++i){
    floors_with_generator |= 1 << g_floor(state, i);
  }
  for(int i = 0; i < N_ITEMS; ++i){
    if(!is_paired(state, i) && ((1 << c_floor(state, i)) & floors_with_generator))
      return 0;
  }
  return 1;
}


struct Node{
  int state;
  int visited;
  int weight;
};

static struct Node *node_create(int state){
  struct Node *n = malloc(sizeof(struct Node));
  n->state = state;
  n->visited = 0;
  n->weight = -1;
  return n;
}

static unsigned int state_hash(const void* data){
  return HM_integer_hash((long)data);
}

static int state_equals(const void* lhs, const void *rhs){
  return (long)lhs == (long)rhs;
}

struct Node *get_node(HashMap h, int state){
  struct Node *n = HM_find(h, (void*)(long)state);
  if (n){
    return n;
  }
  n = node_create(state);
  HM_insert(h, (void*)(long)state, n);
  return n;
}

static void update_weight(struct Node *n, int weight){
  if(n->weight == -1 || n->weight > weight) n->weight = weight;
}

static void push_if_legal(Vector stack, HashMap h, int state, int weight){
  if(is_legal(state)){
    struct Node *n = get_node(h, state);
    if (!n->visited) {
      Vector_push_int(stack, state);
      update_weight(n, weight);
    }
  }
}


static void push_legal_moves(Vector stack, HashMap h, int state, int weight){
  int e = e_floor(state);
  for(int i = 0; i < N_ITEMS*2; ++i){
    if(get_floor(state,i) != e) continue;
    int move_down_state = 0;
    int move_up_state = 0;
    if(e > 0){
      move_down_state = update_state(update_state(state, N_ITEMS*2, e-1), i, e-1);
      push_if_legal(stack, h, move_down_state, weight);
    }
    if(e < 3){
      move_up_state = update_state(update_state(state, N_ITEMS*2, e+1), i, e+1);
      push_if_legal(stack, h, move_up_state, weight);
    }
    for(int j = 0; j < i; ++j){
      if(get_floor(state,j) != e) continue;
      if(e > 0){
        int move_down_state2 = update_state(move_down_state, j, e-1);
        push_if_legal(stack, h, move_down_state2, weight);
      }
      if(e < 3){
        int move_up_state2 = update_state(move_up_state, j, e+1);
        push_if_legal(stack, h, move_up_state2, weight);
      }
    }
  }
}

void solve(int start_state){
  Vector stack = Vector_create_int();
  HashMap h = HM_create(state_hash, state_equals, NULL, free);
  int goal = 0;
  for(int i = 0; i < N_ITEMS*2+1; ++i){
    goal=update_state(goal, i, 3);
  }
  Vector_push_int(stack, goal);
  struct Node *n = get_node(h, goal);
  n->weight = 0;
  int pos = 0;

  while(pos < Vector_size(stack)){
    int state = Vector_data_int(stack)[pos++];
    n = get_node(h, state);
    if(n->visited) continue;
    n->visited = 1;
    if (state == start_state){
      printf("%d\n", n->weight);
    }
    push_legal_moves(stack, h, state, n->weight+1);
  }
  Vector_free(stack);
  HM_destroy(&h);
}

struct Element{
  int id;
  int generator_floor;
  int microchip_floor;
};

struct Element *element_create(int id){
  struct Element *e = malloc(sizeof(struct Element));
  e->id = id;
  return e;
}

void push_generator(HashMap h, const char *s, int length, int floor){
  char *ss = malloc((length+1) * sizeof(char));
  strncpy(ss, s, length);
  ss[length] = 0;
  struct Element *e = HM_find(h, ss);
  if(e){
    e->generator_floor = floor;
    free(ss);
  }
  else{
    e = element_create(HM_size(h));
    e->generator_floor = floor;
    HM_insert(h, ss, e);
  }
}

void push_microchip(HashMap h, const char *s, int length, int floor){
  char *ss = malloc((length+1) * sizeof(char));
  strncpy(ss, s, length);
  ss[length] = 0;
  struct Element *e = HM_find(h, ss);
  if(e){
    e->microchip_floor = floor;
    free(ss);
  }
  else{
    e = element_create(HM_size(h));
    e->microchip_floor = floor;
    HM_insert(h, ss, e);
  }
}

void parseline(regex_t *regex, HashMap h, int floor){
  Vector s = Vector_create_char();
  regmatch_t match[3];
  for(;;){
    char c = fgetc(stdin);
    if(c == '\n' || c == EOF) break;
    Vector_push_char(s, c);
  }
  Vector_push_char(s, 0);
  int res = regexec(regex, Vector_data_char(s), 3, match, 0);
  int pos = 0;
  while(res == 0){
    if(match[1].rm_so != -1){
      push_generator(h, &Vector_data_char(s)[pos+match[1].rm_so], match[1].rm_eo - match[1].rm_so, floor);
    }
    else{
      push_microchip(h, &Vector_data_char(s)[pos+match[2].rm_so], match[2].rm_eo - match[2].rm_so, floor);
    }
    pos += match[0].rm_eo;
    res = regexec(regex, &Vector_data_char(s)[pos], 3, match, 0);
  }
  Vector_free(s);
}

void foreach(void* key, void* value, void *arg){
  (void) key;
  int *start_pos = arg;
  struct Element *e = value;
  *start_pos |= e->generator_floor << (e->id*2);
  *start_pos |= e->microchip_floor << ((e->id+N_ITEMS)*2);
}

int parseinput(int extra_items){
  regex_t regex;
  HashMap h = HM_create(HM_string_hash, HM_string_equal, free, free);
  regcomp(&regex, "([a-z]*) generator|([a-z]*)-compatible", REG_EXTENDED);
  int start_pos = 0;
  for(int i = 0; i < 4; ++i){
    parseline(&regex, h, i);
  }
  regfree(&regex);
  N_ITEMS = HM_size(h) + extra_items;
  HM_foreach(h, foreach, &start_pos);
  HM_destroy(&h);
  return start_pos;
}


void part1(){
  int start_pos = parseinput(0);
  solve(start_pos);
}

void part2(){
  int start_pos = parseinput(2);
  solve(start_pos);
}
