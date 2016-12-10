#include "hashmap.h"

#include <stdlib.h>

struct KeyValue{
  void *key;
  void *value;
  int valid;
};

struct HashMapS{
  struct KeyValue* values;
  int values_size;
  int size;
  HMHashFunc hash;
  HMEqualsFunc equals;
  HMFreeFunc key_free;
  HMFreeFunc value_free;
};

static double const MAX_FILL = 0.8;

static void no_free(void *ptr){
  (void)ptr;
}

static void free_key_value(HashMap h, struct KeyValue kv){
  if(kv.valid){
    h->key_free(kv.key);
    h->value_free(kv.value);
    kv.valid = 0;
  }
}

static struct KeyValue *find(HashMap h, const void *key, HMEqualsFunc equals){
  unsigned int pos = h->hash(key) % h->values_size;
  struct KeyValue *kv = &h->values[pos];
  while(kv->valid){
    if(equals(kv->key, key)){
      return kv;
    }
    ++kv;
    if(kv == h->values + h->values_size){
      kv = &h->values[0];
    }
  }
  return kv;
}

static void insert(HashMap h, void *key, void *value){
  struct KeyValue *kv = find(h, key, h->equals);
  if(kv->valid){
    free_key_value(h, *kv);
  }
  kv->key = key;
  kv->value = value;
  kv->valid = 1;
}

static void increase_size(HashMap h){
  struct KeyValue *values = h->values;
  int values_size = h->values_size;
  h->values_size = values_size*2;
  h->values = calloc(h->values_size, sizeof(struct KeyValue));
  for(int i = 0; i < values_size; ++i){
    struct KeyValue *kv = &values[i];
    if(kv->valid){
      insert(h, kv->key, kv->value);
    }
  }
  free(values);
}

unsigned int HM_integer_hash(unsigned int x) {
  x = ((x >> 16) ^ x) * 0x45d9f3b;
  x = ((x >> 16) ^ x) * 0x45d9f3b;
  x = (x >> 16) ^ x;
  return x;
}

void HM_set_insert(HashMap h, void *key){
  HM_insert(h, key, key);
}

void HM_insert(HashMap h, void *key, void* value){
  if(h->size + 1 > h->values_size * MAX_FILL){
    increase_size(h);
  }

  insert(h, key, value);
  ++h->size;
}

void *HM_find(HashMap h, const void *key){
  struct KeyValue *kv = find(h, key, h->equals);
  return kv->valid ? kv->value : NULL;
}

void HM_foreach(HashMap h, HMForEachFunc func, void *arg){
  for(int i = 0; i < h->values_size; ++i){
    if(h->values[i].valid){
      func(h->values[i].key, h->values[i].value, arg);
    }
  }
}

HashMap HM_create(HMHashFunc hash, HMEqualsFunc equals, HMFreeFunc key_free, HMFreeFunc value_free){
  HashMap h;
  if(hash == NULL || equals == NULL){
    return NULL;
  }
  h = malloc(sizeof(struct HashMapS));
  h->values = calloc(1, sizeof(struct KeyValue));
  h->values_size = 1;
  h->size = 0;
  h->hash = hash;
  h->equals = equals;
  h->key_free = key_free ? key_free : no_free;
  h->value_free = value_free ? value_free : no_free;
  return h;
}

void HM_destroy(HashMap *hp){
  HashMap h = *hp;
  for(int i = 0; i < h->values_size; ++i){
    free_key_value(h, h->values[i]);
  }
  free(h->values);
  free(h);
  *hp = NULL;
}
