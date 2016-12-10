#include "vector.h"

#include <stdlib.h>
#include <string.h>

struct VectorS{
  char *data;
  size_t length;
  size_t real_length;
  size_t element_size;
};

void Vector_push(Vector v, void* data){
  if(v->length + v->element_size > v->real_length){
    while(v->length + v->element_size > v->real_length){
      v->real_length *= 2;
    }
    v->data = realloc(v->data, v->real_length);
  }
  memcpy(&v->data[v->length], data, v->element_size);
  v->length += v->element_size;
}

int Vector_size(Vector v){
  return v->length/v->element_size;
}

void Vector_pop(Vector v, void *elem){
  int new_length = v->length - v->element_size;
  if(new_length >= 0){
    memcpy(elem, &v->data[new_length], v->element_size);
    v->length = new_length;
  }
}
Vector Vector_create_char(void){
  return Vector_create(sizeof(char));
}

void Vector_push_char(Vector v, char c){
  Vector_push(v, &c);
}

char* Vector_data_char(Vector v){
  return v->data;
}

Vector Vector_create(size_t element_size){
  Vector v = malloc(sizeof(struct VectorS));
  v->data = malloc(1);
  v->length = 0;
  v->real_length = 1;
  v->element_size = element_size;
  return v;
}

void Vector_free(Vector v){
  free(v->data);
  free(v);
}
