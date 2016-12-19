#include "aoc-main.h"

#include <stdio.h>
#include <stdlib.h>

void part1(){
  int n;
  scanf("%d\n", &n);
  char *elves = calloc(n, sizeof(char));
  int curelf = 0;
  for(int i = 0; i < n-1; ++i){
    while(elves[curelf]){
      curelf = (curelf + 1)%n;
    }
    curelf = (curelf + 1)%n;
    while(elves[curelf]){
      curelf = (curelf + 1)%n;
    }
    elves[curelf] = 1;
    curelf = (curelf + 1)%n;
  }
  while(elves[curelf]){
    curelf = (curelf + 1)%n;
  }
  free(elves);
  printf("%d\n", curelf+1);
}

void part2(){
  int n;
  scanf("%d\n", &n);
  char *elves = calloc(n, sizeof(char));
  int curelf = 0;
  int stealelf = (n)/2;
  for(int i = 0; i < n-1; ++i){
    elves[stealelf] = 1;
    if((n-i)%2 == 1){
      while(elves[stealelf]){
        stealelf = (stealelf + 1)%n;
      }
    }

    curelf = (curelf + 1)%n;
    while(elves[curelf]){
      curelf = (curelf + 1)%n;
    }
    stealelf = (stealelf + 1)%n;
    while(elves[stealelf]){
      stealelf = (stealelf + 1)%n;
    }
  }
  while(elves[curelf]){
    curelf = (curelf + 1)%n;
  }
  free(elves);
  printf("%d\n", curelf+1);
}
