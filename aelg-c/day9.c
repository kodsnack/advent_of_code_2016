#include "aoc-main.h"
#include "vector.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int rdp(Vector in, int pos, long long *length, int recurse);

long long count_letters(Vector in, int start, int end){
  long long count = 0;
  for(int pos = start; pos < end || (end < 0 && Vector_data_char(in)[pos]);){
    long long length;
    pos = rdp(in, pos, &length, 1);
    count += length;
  }
  return count;
}

int rdp(Vector in, int pos, long long *length, int recurse){
  if(Vector_data_char(in)[pos] == '('){
    int cur_pos = pos;
    int num_letters;
    int repeat;
    char c;
    if (sscanf(&Vector_data_char(in)[pos+1], "%dx%d%c", &num_letters, &repeat, &c) == 3 && c == ')'){
      while(Vector_data_char(in)[cur_pos++] != ')');
      if(recurse){
        *length = count_letters(in, cur_pos, cur_pos + num_letters) * repeat;
      }
      else{
        *length = num_letters * repeat;
      }
      return cur_pos+num_letters;
    }
  }
  if(Vector_data_char(in)[pos] != ' ' && Vector_data_char(in)[pos] != '\n') *length = 1;
  else *length = 0;
  return pos+1;
}

void part1(){
  char c;
  Vector in = Vector_create_char();
  long long count = 0;
  while(scanf("%c", &c) != EOF){
    Vector_push_char(in, c);
  }
  Vector_push_char(in, 0);
  for(int pos = 0; Vector_data_char(in)[pos];){
    long long length;
    pos = rdp(in, pos, &length, 0);
    count += length;
  }
  printf("%lld\n", count);
  Vector_free(in);
}

void part2(){
  char c;
  Vector in = Vector_create_char();
  long long count = 0;
  while(scanf("%c", &c) != EOF){
    Vector_push_char(in, c);
  }
  Vector_push_char(in, 0);
  count = count_letters(in, 0, -1);
  printf("%lld\n", count);
  Vector_free(in);
}
