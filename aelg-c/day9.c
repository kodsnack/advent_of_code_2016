#include "aoc-main.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Vector{
  char *data;
  int length;
  int real_length;
};

void Vector_push(struct Vector *v, void* data, int length){
  if(v->length + length > v->real_length){
      v->real_length *= 2;
      v->data = realloc(v->data, v->real_length);
  }
  memcpy(&v->data[v->length], data, length);
  v->length += length;
}

void Vector_push_char(struct Vector *v, char c){
  Vector_push(v, &c, sizeof(char));
}

struct Vector Vector_create(){
  struct Vector v;
  v.data = malloc(1);
  v.length = 0;
  v.real_length = 1;
  return v;
}

void Vector_free(struct Vector *v){
  free(v->data);
}

int rdp(struct Vector* in, int pos, long long *length, int recurse);

long long count_letters(struct Vector *in, int start, int end){
  long long count = 0;
  for(int pos = start; pos < end || (end < 0 && in->data[pos]);){
    long long length;
    pos = rdp(in, pos, &length, 1);
    count += length;
  }
  return count;
}

int rdp(struct Vector* in, int pos, long long *length, int recurse){
  if(in->data[pos] == '('){
    int cur_pos = pos;
    int num_letters;
    int repeat;
    char c;
    if (sscanf(&in->data[pos+1], "%dx%d%c", &num_letters, &repeat, &c) == 3 && c == ')'){
      while(in->data[cur_pos++] != ')');
      if(recurse){
        *length = count_letters(in, cur_pos, cur_pos + num_letters) * repeat;
      }
      else{
        *length = num_letters * repeat;
      }
      return cur_pos+num_letters;
    }
  }
  if(in->data[pos] != ' ' && in->data[pos] != '\n') *length = 1;
  else *length = 0;
  return pos+1;
}

void part1(){
  char c;
  struct Vector in = Vector_create();
  long long count = 0;
  while(scanf("%c", &c) != EOF){
    Vector_push_char(&in, c);
  }
  for(int pos = 0; in.data[pos];){
    long long length;
    pos = rdp(&in, pos, &length, 0);
    count += length;
  }
  printf("%lld\n", count);
  Vector_free(&in);
}

void part2(){
  char c;
  struct Vector in = Vector_create();
  long long count = 0;
  while(scanf("%c", &c) != EOF){
    Vector_push_char(&in, c);
  }
  count = count_letters(&in, 0, -1);
  printf("%lld\n", count);
  Vector_free(&in);
}
