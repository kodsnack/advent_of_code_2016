#include "aoc-main.h"
#include "vector.h"
#include "hashmap.h"

#include <stdio.h>



struct Pos {
  int x;
  int y;
} DIRS[4] = {
  { 1, 0},
  {-1, 0},
  { 0, 1},
  { 0,-1}
};

unsigned int pos_hash(const void* x){
  const struct Pos *p = x;
  return HM_integer_hash(p->x) + HM_integer_hash(p->y);
}

int pos_equal(const void *data1, const void *data2){
  const struct Pos *lhs = data1;
  const struct Pos *rhs = data2;
  return lhs->x == rhs->x && lhs->y == rhs->y;
}

struct Pos pos_add(struct Pos a, struct Pos b){
  a.x += b.x;
  a.y += b.y;
  return a;
}

struct Pos make_pos(int x, int y){
  struct Pos p = {x, y};
  return p;
}

struct Pos *clone_pos(struct Pos pos){
  struct Pos *p = malloc(sizeof(struct Pos));
  *p = pos;
  return p;
}

struct Node {
  int weight;
  int visited;
};

struct Node *new_node(int weight){
  struct Node *n = malloc(sizeof(struct Node));
  n->weight = weight;
  n->visited = 0;
  return n;
}

int is_open(int input, struct Pos p){
  if(p.x < 0 || p.y < 0) return 0;
  return __builtin_popcount((p.x*p.x + 3*p.x + 2*p.x*p.y + p.y + p.y*p.y) + input)%2 == 0;
}

struct Pos vector_get(Vector q, int n){
  return ((struct Pos*)Vector_data(q))[n];
}

// BFS/Flood fill
int find_length(int input, struct Pos start, struct Pos end, int max_steps){
  int result = -1;
  Vector q = Vector_create(sizeof(struct Pos));
  HashMap h = HM_create(pos_hash, pos_equal, free, free);
  Vector_push(q, &start);
  HM_insert(h, clone_pos(start), new_node(0));
  for(int i = 0; i < Vector_size(q); ++i){
    struct Pos cur = vector_get(q, i);
    struct Node *cur_node = HM_find(h, &cur);
    cur_node->visited = 1;
    if(max_steps && cur_node->weight > max_steps){
      result = i;
      break;
    }
    if(pos_equal(&end, &cur)){
      result = cur_node->weight;
      break;;
    }
    for(int d = 0; d < 4; ++d){
      struct Pos new = pos_add(cur, DIRS[d]);
      if(is_open(input, new)){
        struct Node *n = HM_find(h, &new);
        if(!n){
          n = new_node(cur_node->weight + 1);
          Vector_push(q, &new);
          HM_insert(h, clone_pos(new), n);
        }
      }
    }
  }
  HM_destroy(&h);
  Vector_free(q);
  return result;
}

int read_input(){
  int input;
  scanf("%d", &input);
  return input;
}

void part1(){
  int input = read_input();
  printf("%d\n", find_length(input, make_pos(1,1), make_pos(31, 39), 0));
}

void part2(){
  int input = read_input();
  printf("%d\n", find_length(input, make_pos(1,1), make_pos(-1, -1), 50));
}
