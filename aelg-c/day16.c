#include "aoc-main.h"

#include "vector.h"

#include <stdio.h>

static Vector read_input(){
  char c;
  Vector v = Vector_create_char();
  while(scanf("%c", &c) != EOF){
    if(c != '1' && c != '0')
      break;
    Vector_push_char(v, c);
  }
  return v;
}

static void print(Vector v){
  for(int i = 0; i < Vector_size(v); ++i){
    printf("%c", Vector_as_array(char,v)[i]);
  }
}

static Vector expand(Vector v){
  int size = Vector_size(v);
  Vector vv = Vector_create_char();
  char * cc = Vector_as_array(char, v);
  for(int i = 0; i < size; ++i){
    Vector_push_char(vv, cc[i]);
  }
  Vector_push_char(vv, '0');
  for(int i = size-1; i >= 0; --i){
    Vector_push_char(vv, cc[i] == '0' ? '1' : '0');
  }
  Vector_free(v);
  return vv;
}

static Vector checksum(Vector v){
  int size = Vector_size(v);
  if (size % 2 == 1) return v;
  char *cc = Vector_as_array(char, v);
  Vector vv = Vector_create_char();
  for(int i = 0; i < size; i += 2){
    Vector_push_char(vv, cc[i] == cc[i+1] ? '1' : '0');
  }
  Vector_free(v);
  return checksum(vv);
}

static void cap(Vector v, int n){
  while(Vector_size(v) > n){
    char d;
    Vector_pop(v, &d);
  }
}

Vector solve(int n){
  Vector v = read_input();
  while(Vector_size(v) < n){
    v = expand(v);
  }
  cap(v, n);
  v = checksum(v);
  return v;
}

void part1(){
  Vector v = solve(272);
  print(v);
  printf("\n");
  Vector_free(v);
}

void part2(){
  Vector v = solve(35651584);
  print(v);
  printf("\n");
  Vector_free(v);
}
