#include "vector.h"

#include <stdlib.h>
#include <string.h>

struct VectorS{
  char *data;
  int length;
  int real_length;
};

void Vector_push(Vector v, void* data, int length){
  if(v->length + length > v->real_length){
      v->real_length *= 2;
      v->data = realloc(v->data, v->real_length);
  }
  memcpy(&v->data[v->length], data, length);
  v->length += length;
}

void Vector_push_char(Vector v, char c){
  Vector_push(v, &c, sizeof(char));
}

char* Vector_data_char(Vector v){
  return v->data;
}

Vector Vector_create(){
  Vector v = malloc(sizeof(struct VectorS));
  v->data = malloc(1);
  v->length = 0;
  v->real_length = 1;
  return v;
}

void Vector_free(Vector v){
  free(v->data);
  free(v);
}
