#include "aoc-main.h"
#include "vector.h"
#include "hashmap.h"

#include <stdio.h>

static int N_ITEMS = 7;
static int E = 14; // N_ITEMS*2

static int get_floor(int state, int n){
  return (state >> 2*n) & 3;
}

static int g_floor(int state, int n){
  return get_floor(state, n);
}

static int c_floor(int state, int n){
  return get_floor(state, n + N_ITEMS);
}

static int e_floor(int state){
  return get_floor(state, E);
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

static unsigned int node_hash(const void* data){
  const struct Node *n = data;
  return HM_integer_hash(n->state);
}

static int node_equals(const void* data1, const void *data2){
  const struct Node *lhs = data1;
  const struct Node *rhs = data2;
  return lhs->state == rhs->state;
}

struct Node *get_node(HashMap h, int state){
  struct Node *tmp = node_create(state);
  struct Node *n = HM_find(h, tmp);
  if (n){
    free(tmp);
    return n;
  }
  n = tmp;
  HM_set_insert(h, n);
  return n;
}

static void update_weight(HashMap h, int state, int weight){
  struct Node *n = get_node(h, state);
  if(n->weight == -1 || n->weight > weight) n->weight = weight;
}

static void push_legal_moves(Vector stack, HashMap h, int state, int weight){
  int e = e_floor(state);
  if(e > 0){
    for(int i = 0; i < N_ITEMS*2; ++i){
      if(get_floor(state,i) != e) continue;
      int new_state = update_state(update_state(state, E, e-1), i, e-1);
      if(is_legal(new_state)){
        Vector_push_int(stack, new_state);
        update_weight(h, new_state, weight);
      }
      for(int j = 0; j < i; ++j){
        if(get_floor(state,j) != e) continue;
        int new_state2 = update_state(new_state, j, e-1);
        if(is_legal(new_state2)){
          Vector_push_int(stack, new_state2);
          update_weight(h, new_state2, weight);
        }
      }
    }
  }
  if(e < 3){
    for(int i = 0; i < N_ITEMS*2; ++i){
      if(get_floor(state,i) != e) continue;
      int new_state = update_state(update_state(state, E, e+1), i, e+1);
      if(is_legal(new_state)){
        Vector_push_int(stack, new_state);
        update_weight(h, new_state, weight);
      }
      for(int j = 0; j < i; ++j){
        if(get_floor(state,j) != e) continue;
        int new_state2 = update_state(new_state, j, e+1);
        if(is_legal(new_state2)){
          Vector_push_int(stack, new_state2);
          update_weight(h, new_state2, weight);
        }
      }
    }
  }
}

void solve(){
  Vector stack = Vector_create_int();
  HashMap h = HM_create(node_hash, node_equals, NULL, free);
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
    if (state == ((1 << (2*(N_ITEMS+0))) | (1 << (2*(N_ITEMS+1))))){
      printf("weight: %d\n", n->weight);
    }
    push_legal_moves(stack, h, state, n->weight+1);
  }
  Vector_push_int(stack, goal);
}

void part1(){
  N_ITEMS = 5;
  E = 10;
  solve();
}

void part2(){
  N_ITEMS = 7;
  E = 14;
  solve();
}
