#include "aoc-main.h"
#include "vector.h"
#include "permute.h"

#include <stdio.h>
#include <stdlib.h>


struct Pos {
  int x;
  int y;
} DIR[4] = {
  {1, 0},
  {-1, 0},
  {0, 1},
  {0, -1}
};

struct Location {
  struct Pos pos;
  int n;
};

int comp_location(const void *a, const void *b){
  const struct Location *lhs = a;
  const struct Location *rhs = b;
  return lhs->n - rhs->n;
}

struct Map {
  int width;
  int height;
  Vector v;
  Vector locations;
};

void free_map(struct Map m){
  Vector_free(m.v);
  Vector_free(m.locations);
}

struct Map read_input(){
  int x = 0;
  struct Map m;
  m.width = 0;
  m.height = 0;
  m.v = Vector_create(sizeof(char));
  m.locations = Vector_create(sizeof(struct Location));
  char c;

  for(int i = 0; ; ++i){
    if(scanf("%c", &c) == EOF) return m;
    if(c == '\n'){
      if(m.width && m.width != x) printf("Error!\n");
      m.width = x;
      x = 0;
      ++m.height;
    }
    if(c == '#'){
      c = 0;
      Vector_push(m.v, &c);
      ++x;
    }
    if(c == '.'){
      c = 1;
      Vector_push(m.v, &c);
      ++x;
    }
    if(c >= '0' && c <= '9'){
      struct Location l = {{x, m.height}, c - '0'};
      c = 1;
      Vector_push(m.v, &c);
      Vector_push(m.locations, &l);
      ++x;
    }
  }
}

int is_free(struct Map m, struct Pos pos){
  return Vector_as_array(char, m.v)[pos.x + m.width*pos.y];
}

struct Node {
  struct Pos pos;
  int weight;
};

int get_distance(struct Map m, struct Pos start, struct Pos end){
  char *added = calloc(m.width * m.height, sizeof(char));
  Vector q = Vector_create(sizeof(struct Node));
  struct Node n = {start, 0};
  Vector_push(q, &n);
  added[start.x + start.y*m.width] = 1;
  for(int i = 0; i < Vector_size(q); ++i){
    struct Node cur = Vector_as_array(struct Node, q)[i];
    if(cur.pos.x == end.x && cur.pos.y == end.y) {
      free(added);
      Vector_free(q);
      return cur.weight;
    }
    for(int j = 0; j < 4; ++j){
      struct Node next = {{cur.pos.x + DIR[j].x, cur.pos.y + DIR[j].y}, cur.weight + 1};
      if (added[next.pos.x + next.pos.y*m.width]) continue;
      if (next.pos.x < 0 || next.pos.x >= m.width || next.pos.y < 0 || next.pos.y >= m.height) continue;
      if (!is_free(m, next.pos)) continue;
      added[next.pos.x + next.pos.y*m.width] = 1;
      Vector_push(q, &next);
    }
  }
  free(added);
  Vector_free(q);
  return -1;
}

int get_location_distance(struct Map m, int distance_cache[][10], int from, int to){
  struct Location *l = Vector_as_array(struct Location, m.locations);
  if(!distance_cache[from][to]){
    distance_cache[from][to] = get_distance(m, l[from].pos, l[to].pos);
  }
  return distance_cache[from][to];
}

int find_shortest(struct Map m, int return_to_start){
  int n_locations = Vector_size(m.locations);
  char s[11];
  int min_dist = 1000000;
  qsort(Vector_data(m.locations), n_locations, sizeof(struct Location), comp_location);
  int distance_cache[10][10] = {0}; // Caching distances between locations speeds things up considerably.
  for(int i = 0; i < n_locations; ++i){
    s[i] = i;
  }
  s[n_locations] = 0;
  do {
    int dist = 0;
    int tot_n_locations = return_to_start ? n_locations + 1 : n_locations;
    for(int i = 0; i < tot_n_locations -1; ++i){
      dist += get_location_distance(m, distance_cache, s[i], s[i+1]);
    }
    if(dist < min_dist) min_dist = dist;
  }while (permute(s+1, n_locations-1));

  return min_dist;
}


void part1(){
  struct Map m = read_input();
  int min_dist = find_shortest(m, 0);
  printf("%d\n", min_dist);
  free_map(m);
}

void part2(){
  struct Map m = read_input();
  int min_dist = find_shortest(m, 1);
  printf("%d\n", min_dist);
  free_map(m);
}
