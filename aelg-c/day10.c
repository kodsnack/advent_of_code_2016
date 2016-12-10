#include "aoc-main.h"
#include "hashmap.h"
#include "vector.h"

#include <stdio.h>
#include <stdlib.h>

enum TypeE{
  Bot,
  Value,
  Output
};

struct Node{
  enum TypeE type;
  int id;
  int inputs[2];
  struct Node *low;
  struct Node *high;
};

struct Node *Node_new(enum TypeE type, int id){
  struct Node *n = malloc(sizeof(struct Node));
  n->type = type;
  n->id = id;
  n->inputs[0] = -1;
  n->inputs[1] = -1;
  n->low = 0;
  n->high = 0;
  return n;
}

unsigned int Node_hash(const void* data){
  const struct Node *n = data;
  return HM_integer_hash(n->type) + HM_integer_hash(n->id);
}

int Node_equals(const void *data1, const void* data2){
  const struct Node *lhs = data1;
  const struct Node *rhs = data2;
  return lhs->type == rhs->type && lhs->id == rhs->id;
}

struct Node *get_node(HashMap h, enum TypeE type, int id){
  struct Node to_find;
  struct Node *found;
  to_find.type = type;
  to_find.id = id;
  found = HM_find(h, &to_find);
  if (found) return found;
  struct Node *n = Node_new(type, id);
  HM_set_insert(h, n);
  return n;
}
    

int readline(HashMap h, Vector stack){
  char s[10];
  if(scanf("%s", s) == EOF) return 0;
  if(s[0] == 'b'){
    struct Node *node;
    struct Node *low_node;
    struct Node *high_node;
    char low_type[10];
    char high_type[10];
    int id;
    int low_id;
    int high_id;
    scanf("%d gives low to %s %d and high to %s %d\n", &id, low_type, &low_id, high_type, &high_id);
    low_node = get_node(h, low_type[0] == 'b' ? Bot : Output, low_id);
    high_node = get_node(h, high_type[0] == 'b' ? Bot : Output, high_id);
    node = get_node(h, Bot, id);
    node->low = low_node;
    node->high = high_node;
  }
  else{
    int value;
    int to_id;
    char type[10];
    struct Node *to;
    scanf("%d goes to %s %d\n", &value, type, &to_id);
    to = get_node(h, type[0] == 'b' ? Bot : Output, to_id);
    struct Node *tmp = get_node(h, Value, value);
    tmp->low = to;
    Vector_push(stack, &tmp);
  }
  return 1;
}

void add_input(Vector stack, struct Node *node, int value){
  if(node->inputs[0] == -1){
    node->inputs[0] = value;
  }
  else {
    node->inputs[1] = value;
    Vector_push(stack, &node);
  }
}

static int min(int a, int b){
  return a<b ? a : b;
}

static int max(int a, int b){
  return a>b ? a : b;
}

void solve(Vector stack){
  while(Vector_size(stack)){
    struct Node *n;
    Vector_pop(stack, &n);
    if(n->type == Value){
      add_input(stack, n->low, n->id);
    }
    else if(n->type == Bot){
      add_input(stack, n->low, min(n->inputs[0], n->inputs[1]));
      add_input(stack, n->high, max(n->inputs[0], n->inputs[1]));
    }
  }
}

void part1_finder(void* key, void *value, void *arg){
  (void) key;
  struct Node *node = value;
  if(min(node->inputs[0], node->inputs[1]) == 17 && 
     max(node->inputs[0], node->inputs[1]) == 61){
    *(struct Node**)arg = node;
  }
}

void part1(){
  HashMap h = HM_create(Node_hash, Node_equals, NULL, free);
  Vector stack = Vector_create(sizeof(struct Node*));
  struct Node *n;
  while(readline(h, stack));
  solve(stack);
  
  HM_foreach(h, part1_finder, &n);
  
  printf("%d\n", n->id);
  HM_destroy(&h);
  Vector_free(stack);
}

void part2(){
  HashMap h = HM_create(Node_hash, Node_equals, NULL, free);
  Vector stack = Vector_create(sizeof(struct Node*));
  struct Node *n;
  int ans = 1;
  while(readline(h, stack));
  solve(stack);

  for(int i = 0; i < 3; ++i){
    n = get_node(h, Output, i);
    ans *= n->inputs[0];
  }
  
  HM_destroy(&h);
  Vector_free(stack);
  printf("%d\n", ans);
}
