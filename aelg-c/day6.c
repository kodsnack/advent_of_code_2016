#include "aoc-main.h"

#include <stdio.h>

#define NUM_LETTERS (26)
#define INPUT_SIZE (16)

int readline(char* input){
  return scanf("%s\n", input) != EOF;
}

static void read_input(char t[][NUM_LETTERS]){
  char input[INPUT_SIZE];
  while(readline(input)){
    for(int i=0; input[i]; ++i){
      ++t[i][input[i]-'a'];
    }
  }
}

struct Accumulator{
  int index;
  int value;
};

static void find_max(void *acc, void *next, int index){
  struct Accumulator *max_val = acc;
  char n = *(char*)next;
  if(n > max_val->value){
    max_val->index = index;
    max_val->value = n;
  }
}

static void find_min(void *acc, void *next, int index){
  struct Accumulator *min_val = acc;
  int n = *(char*) next;
  if(n < min_val->value){
    min_val->index = index;
    min_val->value = n;
  }
}

static void fold(void *a,
                 size_t size,
                 int num_elements,
                 void (*func)(void* acc, void* next, int index),
                 void* start_val){
  for(int i = 0; i < num_elements; ++i, a = (char*)a + size){
    func(start_val, a, i);
  }
}


void part1(){
  char t[INPUT_SIZE][NUM_LETTERS] = {0};
  char ans[INPUT_SIZE];
  read_input(t);

  for(int i = 0; i < INPUT_SIZE; ++i){
    struct Accumulator acc = {0, 0};
    fold(t[i], sizeof(char), NUM_LETTERS, find_max, &acc);
    if(acc.value == 0){
      ans[i] = 0; 
      break;
    }
    ans[i] = acc.index + 'a';
  }
  printf("%s\n", ans);
}

void part2(){
  char t[INPUT_SIZE][NUM_LETTERS] = {0};
  char ans[INPUT_SIZE];
  read_input(t);
  for(int i = 0; i < INPUT_SIZE; ++i){
    struct Accumulator acc = {0, 1000};
    fold(t[i], sizeof(char), NUM_LETTERS, find_min, &acc);
    if(acc.value == 0){
      ans[i] = 0; 
      break;
    }
    ans[i] = acc.index + 'a';
  }
  printf("%s\n", ans);
}
