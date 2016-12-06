#include <stdio.h>
#include <stdlib.h>

#include "aoc-main.h"
#include "hashmap.h"

static struct Move{
  int dx;
  int dy;
} MOVE[4] = {
  {0, 1},
  {1, 0},
  {0, -1},
  {-1, 0}
};

static int readinput(char *input, int *length){
  scanf("%1s%d", input, length);
  return scanf(", ") != EOF;
}

static int newdir(int dir, char *input){
  return (dir + 4 + (input[0] == 'R' ? 1 : -1)) % 4;
}


void part1(){
  char input[2];
  int dir = 0;
  int length;
  int x = 0;
  int y = 0;
  while(readinput(input, &length)){
    dir = newdir(dir, input);
    x += MOVE[dir].dx * length;
    y += MOVE[dir].dy * length;
  }
  printf("%d\n", abs(x) + abs(y));
}


struct Pos {
  int x;
  int y;
};

static struct Pos *Pos_new(int x, int y){
  struct Pos *p = malloc(sizeof(struct Pos));
  p->x = x;
  p->y = y;
  return p;
}

static unsigned int Pos_hash(const void* ptr){
  const struct Pos *pos = ptr;
  return HM_integer_hash(pos->x) + HM_integer_hash(pos->y);
}

static int Pos_equals(const void *ptr1, const void *ptr2){
  const struct Pos *lhs = ptr1;
  const struct Pos *rhs = ptr2;
  return lhs->x == rhs->x && lhs->y == rhs->y;
}

void part2(){
  char input[2];
  int length;
  int dir = 0;
  struct Pos curpos = {0, 0};
  HashMap h = HM_create(Pos_hash, Pos_equals, free, NULL);

  HM_set_insert(h, Pos_new(curpos.x,curpos.y));
  while(readinput(input, &length)){
    dir = newdir(dir, input);
    for(int i = 0; i < length; ++i){
      curpos.x += MOVE[dir].dx;
      curpos.y += MOVE[dir].dy;
      if(HM_find(h, &curpos)) {
        printf("%d\n", abs(curpos.x) + abs(curpos.y));
        HM_destroy(&h);
        return;
      }
      HM_set_insert(h, Pos_new(curpos.x,curpos.y));
    }
  }
  printf("Didn't find the end.\n");
  HM_destroy(&h);
}
