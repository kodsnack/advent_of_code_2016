#include <stdlib.h>

typedef struct VectorS *Vector;

void Vector_push(Vector v, void* data);
void Vector_pop(Vector v, void *elem);
int Vector_size(Vector v);

Vector Vector_create_char(void);
void Vector_push_char(Vector v, char c);
char* Vector_data_char(Vector v);

Vector Vector_create(size_t element_size);

void Vector_free(Vector v);
