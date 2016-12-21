#include "aoc-main.h"

#include "vector.h"

#include <stdio.h>
#include <string.h>

Vector read_input(){
  Vector v = Vector_create_char();
  char c;
  while(scanf("%c", &c) != EOF){
    if(c == '.') Vector_push_char(v, 0);
    else if(c == '^') Vector_push_char(v, 1);
    else break;
  }
  return v;
}

int count_row(char* t, int size){
  int sum = 0;
  for(int i = 0; i < size; ++i){
    if (!t[i]) ++sum;
  }
  return sum;
}

int count_safe(Vector v, int rows){
  int size = Vector_size(v);
  int sum = 0;
  char *p_tiles = malloc(size*sizeof(char));
  char *cur_tiles= malloc(size*sizeof(char));
  memcpy(p_tiles, Vector_data(v), size*sizeof(char));
  sum += count_row(p_tiles, size);
  for(int row = 0; row < rows-1; ++row){
    for(int i = 1; i < size-1; ++i){
      cur_tiles[i] = (p_tiles[i-1]^p_tiles[i+1]) ? 1 : 0;
    }
    cur_tiles[0] = p_tiles[1];
    cur_tiles[size-1] = p_tiles[size-2];
    char* tmp = p_tiles;
    p_tiles = cur_tiles;
    cur_tiles = tmp;

    sum += count_row(p_tiles, size);
  }
  free(p_tiles);
  free(cur_tiles);
  return sum;
}

void part1(){
  Vector v = read_input();
  printf("%d\n", count_safe(v, 40));
  Vector_free(v);
}

void part2(){
  Vector v = read_input();
  printf("%d\n", count_safe(v, 400000));
  Vector_free(v);
}
