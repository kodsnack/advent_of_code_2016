#include "aoc-main.h"

#include "vector.h"

#include <stdio.h>
#include <stdlib.h>

struct Interval {
  unsigned int from;
  unsigned int to;
};

void vector_push_interval(Vector v, struct Interval i){
  Vector_push(v, &i);
}

void read_input(Vector v){
  struct Interval i;
  while(scanf("%d-%d\n", &i.from, &i.to) != EOF){
    vector_push_interval(v, i);
  }
}

int compare_interval(const void* a, const void*b){
  struct Interval const *lhs = a;
  struct Interval const *rhs = b;
  return lhs->from < rhs->from ? -1 : 1;
}

Vector merge_intervals(Vector v){
  Vector out = Vector_create(sizeof(struct Interval));
  qsort(Vector_data(v), Vector_size(v), sizeof(struct Interval), compare_interval);
  int i = 0;
  struct Interval *intervals = Vector_as_array(struct Interval, v);
  struct Interval merged;
  while(i < Vector_size(v)){
    merged = intervals[i];
    ++i;
    while(i < Vector_size(v) && intervals[i].from <= ((merged.to + 1U) == 0 ? merged.to : (merged.to + 1U))){
      if(merged.to < intervals[i].to) merged.to = intervals[i].to;
      ++i;
    }
    Vector_push(out, &merged);
  }
  return out;
}

void part1(){
  Vector v = Vector_create(sizeof(struct Interval));
  read_input(v);
  Vector merged = merge_intervals(v);
  printf("%d\n", Vector_as_array(struct Interval, merged)[0].to + 1);
}

void part2(){
  Vector v = Vector_create(sizeof(struct Interval));
  read_input(v);
  Vector merged = merge_intervals(v);
  unsigned int sum = 0;
  struct Interval *intervals = Vector_as_array(struct Interval, merged);
  sum += intervals[0].from;
  for(int i = 0; i < Vector_size(merged) - 1; ++i){
    sum += intervals[i+1].from - intervals[i].to - 1;
  }
  sum += 0UL - intervals[Vector_size(merged)-1].to - 1;
  printf("%u\n", sum);
}
