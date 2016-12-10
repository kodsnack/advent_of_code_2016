
typedef struct VectorS *Vector;

void Vector_push_char(Vector v, char c);
char* Vector_data_char(Vector v);

Vector Vector_create();

void Vector_free(Vector v);
