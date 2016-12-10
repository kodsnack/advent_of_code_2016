
#ifndef NULL
#define NULL ((void*)0)
#endif

typedef struct HashMapS *HashMap;
typedef unsigned int (*HMHashFunc)(const void*);
typedef int (*HMEqualsFunc)(const void*, const void*);
typedef void (*HMFreeFunc)(void*);

typedef void (HMForEachFunc)(void* key, void* value, void* arg);

unsigned int HM_integer_hash(unsigned int x);

void HM_insert(HashMap h, void *key, void* value);
void HM_set_insert(HashMap h, void *key);
void *HM_find(HashMap h, const void *key);
void HM_foreach(HashMap h, HMForEachFunc func, void *arg);

HashMap HM_create(HMHashFunc hFunc, HMEqualsFunc eFunc, HMFreeFunc keyFreeFunc, HMFreeFunc valueFreeFunc);
void HM_destroy(HashMap *h);

