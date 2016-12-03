#include <stdio.h>
#include <string.h>

#include "aoc-main.h"

static struct Move{
  int dx;
  int dy;
} MOVE[4] = {
  {0, 1},
  {1, 0},
  {0, -1},
  {-1, 0}
};

static int abs(int n){
  return n > 0 ? n : -n;
}

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

#define SIZE  1000
void part2(){
  const int ORIGIN = SIZE/2;
  static int map[SIZE][SIZE];
  char input[2];
  int length;
  int dir = 0;
  int x = ORIGIN;
  int y = ORIGIN;
  
  memset(&map, 0, sizeof(map));
  map[x][y] = 1;
  while(readinput(input, &length)){
    dir = newdir(dir, input);
    for(int i = 0; i < length; ++i){
      x += MOVE[dir].dx;
      y += MOVE[dir].dy;
      if (x < 0 || y < 0 || x > SIZE-1 || y > SIZE -1){
        printf("Out of bounds.\n");
        return;
      }
      if(map[x][y]) {
        printf("%d\n", abs(x-ORIGIN) + abs(y-ORIGIN));
        return;
      }
      map[x][y] = 1;
    }
  }
  printf("Didn't find the end.\n");
  return;
}
