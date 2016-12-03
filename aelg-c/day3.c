#include "aoc-main.h"

#include <stdio.h>

struct Triangle {
  int a, b, c;
};

struct Triangle readTriangle(void){
  struct Triangle tr = {-1, -1, -1};
  scanf("%d %d %d\n", &tr.a, &tr.b, &tr.c);
  return tr;
}

void readTriangleGroup(struct Triangle *trG){
  scanf("%d %d %d\n", &trG[0].a, &trG[1].a, &trG[2].a);
  scanf("%d %d %d\n", &trG[0].b, &trG[1].b, &trG[2].b);
  scanf("%d %d %d\n", &trG[0].c, &trG[1].c, &trG[2].c);
}

int isValidTriangle(struct Triangle tr){
  return tr.a + tr.b > tr.c && tr.a + tr.c > tr.b && tr.b + tr.c > tr.a;
}

void part1(){
  int nValid = 0;
  for(;;){
    struct Triangle tr = readTriangle();
    if(tr.a == -1){
      printf("%d\n", nValid);
      return;
    }
    if(isValidTriangle(tr)){
      ++nValid;
    }
  }
}

void part2(){
  int nValid = 0;
  for(;;){
    struct Triangle trG[3];
    trG[0].a = -1;
    readTriangleGroup(trG);
    if(trG[0].a == -1){
      printf("%d\n", nValid);
      return;
    }
    for(int i = 0; i < 3; ++i){
      if(isValidTriangle(trG[i])){
        ++nValid;
      }
    }
  }
}
