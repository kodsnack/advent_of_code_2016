
#include "hashmap.h"

#include <stdio.h>
#include <stdlib.h>

#define RED  "\033[0;31m"
#define GREEN  "\033[0;32m"
#define RESET  "\033[0;0m"

#define ASSERT(exp) if(!(exp)){ printf(RED "FAIL: " #exp "\n" RESET); exit(-1);}

static unsigned int ident(const void* ptr){
  return (long)ptr;
}

static unsigned int good_hash(const void* ptr){
  return (long)ptr*1000007;
}

static unsigned int bad_hash(const void* ptr){
  (void) ptr;
  return 1000007;
}

static int ptr_equals(const void* ptr1, const void* ptr2){
  return (long)ptr1 == (long)ptr2;
}

static void insert(HashMap h, long key, long value){
  HM_insert(h, (void*)key, (void*)value);
}

static long find(HashMap h, long key){
  return (long)HM_find(h, (void*)key);
}

void basic_usage(){
  HashMap h = HM_create(ident, ptr_equals, NULL, NULL);
  insert(h, 1, 10);
  insert(h, 2, 20);
  insert(h, 2, 20);
  insert(h, 2, 20);
  insert(h, 3, 30);
  insert(h, 4, 40);
  ASSERT(find(h, 1) == 10);
  ASSERT(find(h, 2) == 20);
  ASSERT(find(h, 3) == 30);
  ASSERT(find(h, 4) == 40);
  ASSERT(find(h, 5) == 0);
  ASSERT(find(h, 6) == 0);
  ASSERT(find(h, 7) == 0);
  ASSERT(find(h, 8) == 0);
  HM_destroy(&h);
  ASSERT(h == NULL);
}

void foreach(void *key, void *value, void* arg){
  long k = (long) key;
  long v = (long) value;
  int * a = arg;
  ASSERT(v == k*10);
  ++(*a);
}

void many_entries(HMHashFunc hash, int num_entries){
  HashMap h = HM_create(hash, ptr_equals, NULL, NULL);
  for(int i = 0; i < num_entries; ++i){
    insert(h, i, i*10);
  }
  for(int i = 0; i < num_entries; ++i){
    ASSERT(find(h, i) == i*10);
  }
  for(int i = num_entries; i < 2*num_entries; ++i){
    ASSERT(find(h, i) == 0);
  }

  int counter = 0;
  HM_foreach(h, foreach, &counter);
  ASSERT(counter == num_entries);

  HM_destroy(&h);
}


struct Pos {
  long x;
  long y;
};

static int number_of_pos = 0;

static struct Pos *pos_new(long x, long y){
  struct Pos *pos = malloc(sizeof(struct Pos));
  pos->x = x;
  pos->y = y;
  ++number_of_pos;
  return pos;
}

void pos_free(void *ptr){
  --number_of_pos;
  free(ptr);
}

static unsigned int pos_hash(const void* ptr){
  const struct Pos *pos = ptr;
  return good_hash((void*)pos->x) + good_hash((void*)pos->x);
}

static int pos_equals(const void *ptr1, const void *ptr2){
  const struct Pos *lhs = ptr1;
  const struct Pos *rhs = ptr2;
  return lhs->x == rhs->x && lhs->y == rhs->y;
}

void custom_frees(int num_entries){
  HashMap h = HM_create(pos_hash, pos_equals, pos_free, pos_free);
  for(int i = 0; i < num_entries; ++i){
    int before_insert = number_of_pos;
    HM_insert(h, pos_new(i, i*123), pos_new(i*432, i*10));
    ASSERT(before_insert + 2 == number_of_pos); // Inserted 2 new key-values.
    int before_replace = number_of_pos;
    HM_insert(h, pos_new(i, i*123), pos_new(i*432, i*10));
    ASSERT(before_replace == number_of_pos); // Replaced, old values removed.
  }
  for(int i = 0; i < num_entries; ++i){
    struct Pos* key = pos_new(i, i*123);
    struct Pos* value = pos_new(i*432, i*10);
    ASSERT(pos_equals(HM_find(h, key),  value));
    HM_insert(h, pos_new(i, i*123), pos_new(i*432, i*10));
    pos_free(key); // Free since they were created for the comparison.
    pos_free(value);
  }
  HM_destroy(&h);
  ASSERT(number_of_pos == 0);

}

int main(){
  basic_usage();

  many_entries(good_hash, 100000);

  many_entries(bad_hash, 1000);

  custom_frees(100000);
}
