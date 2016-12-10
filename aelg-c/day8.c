#include "aoc-main.h"

#include <stdio.h>
#include <stdlib.h>

#define WIDTH 50
#define HEIGHT 6

enum Type {
  rect,
  rotate_row,
  rotate_column
};

struct CMD{
  enum Type type;
  int a;
  int b;
  struct CMD *next;
};

int readline(struct CMD *cmd){
  char s[10];
  if(scanf("%s ", s) == EOF) return 0;
  if(s[1] == 'e'){
    cmd->type = rect;
    scanf("%dx%d\n", &cmd->a, &cmd->b);
  }
  else{
    scanf("%s ", s);
    if(s[0] == 'r'){
      cmd->type = rotate_row;
      scanf("y=%d by %d\n", &cmd->a, &cmd->b);
    }
    else{
      cmd->type = rotate_column;
      scanf("x=%d by %d\n", &cmd->a, &cmd->b);
    }
  }
  return 1;
}

struct CMD *readall(){
  struct CMD cmd;
  struct CMD *list = NULL;
  while(readline(&cmd)){
    struct CMD *new = malloc(sizeof(struct CMD));
    *new = cmd;
    new->next = list;
    list = new;
  }
  return list;
}

void free_cmd(struct CMD *list){
  struct CMD *prev;
  while(list){
    prev = list;
    list = list->next;
    free(prev);
  }
}

int solve(int print){
  int sum = 0;
  struct CMD *list = readall();
  for(int j = 0; j < HEIGHT; ++j){
    if(print) printf("\n");
    for(int i = 0; i < WIDTH; ++i){
      struct CMD *cur = list;
      int x = i;
      int y = j;
      int found=0;
      while(cur){
        if(cur->type == rect){
          if(x < cur->a && y < cur->b){
            ++sum;
            found = 1;
            break;
          }
        }
        else if(cur->type == rotate_column){
          if(x == cur->a) y = (HEIGHT + y - cur->b ) % HEIGHT;
        }
        else if(cur->type == rotate_row){
          if(y == cur->a) x = (WIDTH + x - cur->b ) % WIDTH;
        }
        cur = cur->next;
      }
      if(print){
        if(found) printf("|");
        else printf(" ");
      }
    }
  }
  free_cmd(list);
  return sum;
}

void part1(){
  printf("%d\n", solve(0));
}

void part2(){
  solve(1);
  printf("\n");
}
