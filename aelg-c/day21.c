#include "aoc-main.h"
#include "vector.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LENGTH 8

enum Type{
  SwapPosition,
  SwapLetter,
  ReversePosition,
  RotateLeft,
  RotateRight,
  RotateLetter,
  Reverse,
  Move
};

struct Action {
  enum Type type;
  int a;
  int b;
};

void swap(char *a, char *b){
  char tmp = *a;
  *a = *b;
  *b = tmp;
}

void swapp(char **a, char **b){
  char *tmp = *a;
  *a = *b;
  *b = tmp;
}

void read_swap_letter(Vector v){
  char a;
  char b;
  struct Action action;
  scanf("%c with letter %c\n", &a, &b);
  action.type = SwapLetter;
  action.a = a;
  action.b = b;
  Vector_push(v, &action);
}

void swap_letter(struct Action action, char *in, char *out){
  int a = action.a;
  int b = action.b;
  for(int i = 0; i < LENGTH; ++i){
    if(in[i] == a) out[i] = b;
    else if(in[i] == b) out[i] = a;
    else out[i] = in[i];
  }
}

void read_swap_position(Vector v){
  char a;
  char b;
  struct Action action;
  scanf("%d with position %d\n", &a, &b);
  action.type = SwapPosition;
  action.a = a;
  action.b = b;
  Vector_push(v, &action);
}

void swap_position(struct Action action, char *in, char *out){
  int a = action.a;
  int b = action.b;
  for(int i = 0; i < LENGTH; ++i){
    if(i == a) out[i] = in[b];
    else if(i == b) out[i] = in[a];
    else out[i] = in[i];
  }
}

void read_swap(Vector v){
  char b[10];
  scanf("%s ", b);
  if(b[0] == 'p') read_swap_position(v);
  if(b[0] == 'l') read_swap_letter(v);
}

void read_move(Vector v){
  char a;
  char b;
  struct Action action;
  scanf("position %d to position %d\n", &a, &b);
  action.type = Move;
  action.a = a;
  action.b = b;
  Vector_push(v, &action);
}

void do_move(struct Action action, char *in, char *out){
  int from = action.a;
  int to = action.b;
  char *ii = in;
  char moved = in[from];
  for(int i = 0; i < LENGTH; ++i){
    if(in - ii == from){
      in++;
    }
    else if(i == to){
      *(out++) = moved;
    }
    *(out++) = *(in++);
  }
}

void read_reverse(Vector v){
  char a;
  char b;
  struct Action action;
  scanf("positions %d through %d\n", &a, &b);
  action.type = Reverse;
  action.a = a;
  action.b = b;
  Vector_push(v, &action);
}

void do_reverse(struct Action action, char *in, char *out){
  int a = action.a;
  int b = action.b;
  int len;
  for(int i = 0; i < a; ++i){
    out[i] = in[i];
  }
  for(int i = a; i <= b; ++i){
    out[i] = in[b - (i-a)];
  }
  for(int i = b+1; i < LENGTH; ++i){
    out[i] = in[i];
  }
}

void read_rotate_left(Vector v){
  char steps;
  struct Action action;
  scanf("%d steps\n", &steps);
  action.type = RotateLeft;
  action.a = steps;
  Vector_push(v, &action);
}

void rotate_left(struct Action action, char *in, char *out){
  int steps = action.a;
  for(int i = 0; i < LENGTH; ++i){
    out[i] = in[(i+steps)%LENGTH];
  }
}

void read_rotate_right(Vector v){
  char steps;
  struct Action action;
  scanf("%d steps\n", &steps);
  action.type = RotateRight;
  action.a = steps;
  Vector_push(v, &action);
}

void right(char *in, char *out, int steps){
  for(int i = 0; i < LENGTH; ++i){
    out[(i+steps)%LENGTH] = in[i];
  }
}

void rotate_right(struct Action action, char *in, char *out){
  int steps = action.a;
  right(in, out, steps);
}

void read_rotate_letter(Vector v){
  char c;
  struct Action action;
  scanf("on position of letter %c\n", &c);
  action.type = RotateLetter;
  action.a = c;
  Vector_push(v, &action);
}

void rotate_letter(struct Action action, char *in, char *out){
  char c = action.a;
  int index;
  for(int i = 0; i < LENGTH; ++i){
    if(in[i] == c) index = i;
  }
  if(index >= 4) ++index;
  right(in, out, index + 1);
}

void read_rotate(Vector v){
  char b[10];
  scanf("%s ", b);
  if(b[0] == 'l') read_rotate_left(v);
  else if(b[0] == 'r') read_rotate_right(v);
  else if(b[0] == 'b') read_rotate_letter(v);
}

int read_line(Vector v){
  char b[10];
  if(scanf("%s ", b) == EOF) return 0;
  if(b[0] == 's') read_swap(v);
  else if(b[0] == 'm') read_move(v);
  else if(b[1] == 'e') read_reverse(v);
  else if(b[1] == 'o') read_rotate(v);
  return 1;
}

int run_action(struct Action action, char *in, char *out){
  switch (action.type){
    case SwapPosition:
      swap_position(action, in, out);
      break;
    case SwapLetter:
      swap_letter(action, in, out);
      break;
    case ReversePosition:
      do_reverse(action, in, out);
      break;
    case RotateLeft:
      rotate_left(action, in, out);
      break;
    case RotateRight:
      rotate_right(action, in, out);
      break;
    case RotateLetter:
      rotate_letter(action, in, out);
      break;
    case Reverse:
      do_reverse(action, in, out);
      break;
    case Move:
      do_move(action, in, out);
      break;
  }
}

Vector read_input(){
  Vector v = Vector_create(sizeof(struct Action));
  while(read_line(v));
  return v;
}

void solve(Vector v, char *ans){
  char *a = malloc(LENGTH*sizeof(char));
  char *b = malloc(LENGTH*sizeof(char));
  memcpy(a, ans, LENGTH*sizeof(char));
  for(int i = 0; i < Vector_size(v); ++i){
    run_action(Vector_as_array(struct Action, v)[i], a, b);
    swapp(&a, &b);
  }
  memcpy(ans, a, LENGTH*sizeof(char));
}

void part1(){
  Vector v = read_input();
  char ans[9] = "abcdefgh";
  solve(v, ans);
  printf("%s\n", ans);
}

//http://stackoverflow.com/a/3928241
int permute(char* s, int len){

	//find largest j such that set[j] < set[j+1]; if no such j then done
	int i;
  int j = -1;
  int k;
  int l;
  char c;
  int lastpermutation = 0;
	for (i = 0; i < len; i++)
	{
		if (s[i+1] > s[i])
		{
			j = i;
		}
	}
	if (j == -1)
	{
		lastpermutation = 1;
	}
	if (!lastpermutation)
	{
		for (i = j+1; i < len; i++)
		{
			if (s[i] > s[j])
			{
				l = i;
			}
		}
		c = s[j];
		s[j] = s[l];
		s[l] = c;
		//reverse j+1 to end
		k = (len-1-j)/2; // number of pairs to swap
		for (i = 0; i < k; i++)
		{
			c = s[j+1+i];
			s[j+1+i] = s[len-1-i];
			s[len-1-i] = c;
		}
		//printf("%s\n",s);
	}
  return !lastpermutation;
}

void part2(){
  char scrambled[9] = "fbgdceah";
  char permuted[9] = "abcdefgh";
  char s[9];
  Vector v = read_input();
  for(;;){

    memcpy(s, permuted, LENGTH*sizeof(char));
    solve(v, s);
    if(memcmp(s, scrambled, LENGTH*sizeof(char)) == 0){
      printf("%s\n", permuted);
      return;
    }
    permute(permuted, LENGTH);
  }
}

