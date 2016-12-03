#include "aoc-main.h"

#include <stdio.h>

enum Action{
  UP,
  RIGHT,
  DOWN,
  LEFT
};

// Finite state machine.
// fsm[state][action] == new state
static int FSM_part1[9][4] = {
  {1, 2, 4, 1},
  {2, 3, 5, 1},
  {3, 3, 6, 2},
  {1, 5, 7, 4},
  {2, 6, 8, 4},
  {3, 6, 9, 5},
  {4, 8, 7, 7},
  {5, 9, 8, 7},
  {6, 9, 9, 8}
};

static int FSM_part2[13][4] = {
  { 1,  1,  3,  1},
  { 2,  3,  6,  2},
  { 1,  4,  7,  2},
  { 4,  4,  8,  3},
  { 5,  6,  5,  5},
  { 2,  7, 10,  5},
  { 3,  8, 11,  6},
  { 4,  9, 12,  7},
  { 9,  9,  9,  8},
  { 6, 11, 10, 10},
  { 7, 12, 13, 10},
  { 8, 12, 12, 11},
  {11, 13, 13, 13}
};

static int stepFSM(int fsm[][4], int cur, enum Action action){
  return fsm[cur-1][action];
}

static int move(int fsm[][4], int cur, char action){
  switch(action){
    case 'U':
      return stepFSM(fsm, cur, UP);
    case 'R':
      return stepFSM(fsm, cur, RIGHT);
    case 'D':
      return stepFSM(fsm, cur, DOWN);
    case 'L':
      return stepFSM(fsm, cur, LEFT);
  }
  return cur;
}

void solve(int fsm[][4]){
  int ans = 0;
  int cur = 5;
  for(;;){
    char c;
    if(scanf("%c", &c) == EOF){
      printf("%X\n", ans);
      return;
    }
    else if(c == '\n'){
      ans = ans * 0x10;
      ans += cur;
    }
    cur = move(fsm, cur, c);
  };
}

void part1(){
  solve(FSM_part1);
}

void part2(){
  solve(FSM_part2);
}
