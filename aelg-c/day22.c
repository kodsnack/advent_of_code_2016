#include "aoc-main.h"
#include "vector.h"

#include <stdio.h>
#include <time.h>

#define PRINT 0


struct Node {
  int x;
  int y;
  int used;
  int total;
  int visited;
};

void skip_line(){
  char c;
  do{
    scanf("%c", &c);
  }while(c != '\n');
}

int read_line(Vector v){
  struct Node n;
  int res;
  res = scanf("/dev/grid/node-x%d-y%d", &n.x, &n.y);
  if(res == EOF) return 0;
  scanf("%dT", &n.total);
  scanf("%dT", &n.used);
  skip_line();
  n.visited = 0;
  Vector_push(v, &n);
  return 1;
}

Vector read_input(){
  Vector v = Vector_create(sizeof(struct Node));
  skip_line();
  skip_line();
  while(read_line(v));
  return v;
}


void part1(){
  Vector v = read_input();
  int count = 0;
  struct Node *n = Vector_as_array(struct Node, v);
  for(int i = 0; i < Vector_size(v); ++i){
    for(int j = 0; j < Vector_size(v); ++j){
      if(n[i].used == 0) continue;
      if(i == j) continue;
      if(n[i].used + n[j].used <= n[j].total) ++count;
    }
  }
  printf("%d\n", count);
  Vector_free(v);
}

struct Pos{
  int x;
  int y;
  int weight;
} DIR[4] = {
  {1, 0, 0},
  {-1, 0, 0},
  {0, 1, 0},
  {0, -1, 0}
};

int length(Vector v){
  Vector q = Vector_create(sizeof(struct Pos));
  struct Pos start;
  struct Node *n = Vector_as_array(struct Node, v);
  int max_x = 0;
  int max_y = 0;
  for(int i = 0; i < Vector_size(v); ++i){
    if(n[i].used == 0){
      start.x = n[i].x;
      start.y = n[i].y;
    }
    if(n[i].x > max_x) max_x = n[i].x;
    if(n[i].y > max_y) max_y = n[i].y;
  }
  start.weight = 0;
  Vector_push(q, &start);
  int i = 0;
  for(;i < Vector_size(q);++i){
    if(PRINT){
      printf("\n"); // Seems to be worst case scenario for flood fill :)
      printf("\n"); // but it's correct at least.
      for(int i = 0; i < Vector_size(v); ++i){
        if(n[i].y == 0) printf("\n");
        else if(n[i].visited == 1) printf("X");
        else if(n[i].used == 0) printf("_");
        else if(n[i].used > 80 || n[i].total < 80) printf("/");
        else if(n[i].used >100) printf("#");
        else printf(".");
      }
      struct timespec tim;
      tim.tv_sec = 0;
      tim.tv_nsec = 5000000;
      nanosleep(&tim, NULL);
    }
    struct Pos cur = Vector_as_array(struct Pos, q)[i];
    struct Node *cur_node = &Vector_as_array(struct Node, v)[cur.x*(max_y+1) + cur.y];
    if(cur_node->visited) continue;
    cur_node->visited = 1;
    if(cur.x == max_x - 1 && cur.y == 0){
      Vector_free(q);
      return cur.weight;
    }
    for(int j = 0; j < 4; ++j){
      // Assuming sorted input (with y changing fast).
      struct Pos next = {cur.x + DIR[j].x, cur.y + DIR[j].y, cur.weight+1};
      if(next.x >= max_x || next.x < 0 || next.y >= max_y || next.y < 0) continue;
      struct Node *next_node = &Vector_as_array(struct Node, v)[next.x*(max_y+1) + next.y];
      if(next_node->used > 100) continue;
      //if(next_node->visited) continue;
      Vector_push(q, &next);
    }
  }
  printf("Error %d !!\n", i);
  Vector_free(q);
  return 0;
}


void part2(){
  Vector v = read_input();
  int count = 0;
  struct Node *n = Vector_as_array(struct Node, v);
  int max_x = 0;
  for(int i = 0; i < Vector_size(v); ++i){
    if(n[i].y < 2 && n[i].used > 100 ){
      printf("ERROR: Need better algorithm!\n");
      return;
    }
    if(n[i].x > max_x) max_x = n[i].x;
  }
  count += length(v);
  ++count;
  count += 5 * (max_x-1);
  printf("%d\n", count);
  Vector_free(v);
}
