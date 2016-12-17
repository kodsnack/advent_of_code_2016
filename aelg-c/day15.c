#include "aoc-main.h"
#include "vector.h"

#include <stdio.h>

struct Disc{
  int period;
  int start;
};

int readline(struct Disc * d){
  int dummy;
  return scanf("Disc #%d has %d positions; at time=0, it is at position %d.\n", &dummy, &d->period, &d->start) != EOF;
}

int add_time(struct Disc d, int t){
  return (d.start + t + d.period) % d.period;
}

Vector read_input(){
  int i = 1;
  struct Disc d;
  Vector v = Vector_create(sizeof(struct Disc));
  while(readline(&d)){
    d.start = add_time(d, i);
    ++i;
    Vector_push(v, &d);
  }
  return v;
}

int solve(Vector v){
  int t;
  for(t = 0;; ++t){
    int lined_up = 1;
    for(int i = 0; i < Vector_size(v); ++i){
      struct Disc *d = &Vector_as_array(struct Disc, v)[i];
      if(add_time(*d, t) != 0){
        lined_up = 0;
        break;
      }
    }
    if(lined_up) break;
  }
  return t;
}

void part1(){
  Vector v = read_input();
  printf("%d\n", solve(v));
}

void part2(){
  Vector v = read_input();
  struct Disc d = {11, 0};
  d.start = add_time(d, Vector_size(v) + 1);
  Vector_push(v, &d);
  printf("%d\n", solve(v));
}
