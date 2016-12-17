#include "aoc-main.h"

#include "vector.h"

#include <stdio.h>
#include <openssl/md5.h>

struct Pos {
  int x;
  int y;
  Vector path;
};

struct Direction {
  int x;
  int y;
  char d;
} DIRS[4] = {
  { 0,-1, 'U'},
  { 0, 1, 'D'},
  {-1, 0, 'L'},
  { 1, 0, 'R'},
};


struct Pos vector_get(Vector q, int n){
  return ((struct Pos*)Vector_data(q))[n];
}

struct Pos pos_add(struct Pos a, struct Direction dir){
  a.x += dir.x;
  a.y += dir.y;
  a.path = Vector_copy(a.path);
  Vector_push_char(a.path, dir.d);
  return a;
}

void concat(Vector out, Vector next){
  int size = Vector_size(next);
  char *s = Vector_as_array(char, next);
  for(int i = 0; i < size; ++i){
    Vector_push_char(out, s[i]);
  }
}

Vector create_hash(Vector input, Vector path){
  Vector v = Vector_create_char();
  concat(v, input);
  concat(v, path);
  return v;
}

unsigned char *calc_md5(Vector path){
  return MD5((unsigned char*)Vector_as_array(char, path), Vector_size(path), 0);
}

int is_open(unsigned char *md5, int d){
  if(d == 0) return (md5[0] >> 4) > 0xa;
  if(d == 1) return (md5[0] & 0xf) > 0xa;
  if(d == 2) return (md5[1] >> 4) > 0xa;
  if(d == 3) return (md5[1] & 0xf) > 0xa;
  return 0;
}

Vector find_path(Vector input, int shortest){
  Vector found_path = 0;
  Vector q = Vector_create(sizeof(struct Pos));
  struct Pos start = {0, 0, Vector_create_char()};
  Vector_push(q, &start);
  for(int i = 0; i < Vector_size(q); ++i){
    struct Pos cur = vector_get(q, i);
    if(cur.x == 3 && cur.y == 3){
      if(shortest){
        found_path = Vector_copy(cur.path);
        break;
      }
      else if (found_path == 0 || Vector_size(cur.path) > Vector_size(found_path)){
        if(found_path) Vector_free(found_path);
        found_path = Vector_copy(cur.path);
      }
      continue;
    }
    Vector hash = create_hash(input, cur.path);
    unsigned char *md5 = calc_md5(hash);
    Vector_free(hash);
    for(int d = 0; d < 4; ++d){
      if(is_open(md5, d)){
        struct Pos new = pos_add(cur, DIRS[d]);
        if(new.x >= 0 &&  new.x < 4 && new.y >= 0 &&  new.y < 4)
          Vector_push(q, &new);
        else
          Vector_free(new.path);
      }
    }
  }
  for(int i = 0; i < Vector_size(q); ++i){
    struct Pos cur = vector_get(q, i);
    Vector_free(cur.path);
  }
  Vector_free(q);
  return found_path;
}

static void print_path(Vector path){
  int size = Vector_size(path);
  for(int i = 0; i < size; ++i){
    printf("%c", Vector_as_array(char, path)[i]);
  }
  printf("\n");
}

static Vector read_input(){
  char c;
  Vector v = Vector_create_char();
  while(scanf("%c", &c) != EOF){
    if(c == '\n')
      break;
    Vector_push_char(v, c);
  }
  return v;
}

void part1(){
  Vector input = read_input();
  Vector path = find_path(input, 1);
  print_path(path);
  Vector_free(input);
  Vector_free(path);
}

void part2(){
  Vector input = read_input();
  Vector path = find_path(input, 0);
  printf("%d\n", Vector_size(path));
  Vector_free(input);
  Vector_free(path);
}
