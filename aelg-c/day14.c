#include "aoc-main.h"

#include <stdio.h>
#include <string.h>
#include <openssl/md5.h>

#include "vector.h"

struct Hash {
  int n;
  char t;
  char q;
};

struct Hash make_triple(int n, char t){
  struct Hash h;
  h.n = n;
  h.t = t;
  h.q = -1;
  return h;
}

struct Hash make_quintuple(int n, char q){
  struct Hash h;
  h.n = n;
  h.t = -1;
  h.q = q;
  return h;
}

struct Generator{
  char input[100];
  char *end_of_id;
  int salt_len;
  int id_len;
  int next_salt_len_increase;
  int n;
};

void init_generator(struct Generator *g, char* input){
  strcpy(g->input, input);
  g->salt_len = 1;
  g->id_len = strlen(input);
  g->end_of_id = g->input + g->id_len;
  g->next_salt_len_increase = 10;
  g->n = 0;
}


static void int2string(char* s, int n, int len){
  s[len] = 0;
  while(len--){
    s[len] = n%10 + '0';
    n = n/10;
  }
}

void read_input(char *input){
  scanf("%s", input);
}

static const char to_char[16] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

void calculate_key(struct Generator *g, Vector q, int n, int stretch){
  unsigned char *d;

  while(Vector_size(q) <= n){
    if(g->n == g->next_salt_len_increase) ++g->salt_len, g->next_salt_len_increase *= 10;
    int2string(g->end_of_id, g->n, g->salt_len);
    char buff[32];
    d = MD5((unsigned char*)g->input, g->id_len + g->salt_len, 0);
    for(int b = 0; b < stretch; ++b){
      for (int a = 0; a < MD5_DIGEST_LENGTH; ++a){
        buff[a*2] = to_char[d[a]>>4];
        buff[a*2+1] = to_char[d[a]&0xf];
      }
      d = MD5((unsigned char*)buff, 32, 0);
    }
    for(int pos = 0; pos+1 < MD5_DIGEST_LENGTH; ++pos){
      unsigned char matchee1 = d[pos];
      unsigned char matchee2 = d[pos+1];
      for(unsigned char match = 0x00; match != 0x10; match += 0x11){
        unsigned single = match/0x11;
        if((matchee1 == match && (d[pos+1] >> 4) == single) ||
           (matchee2 == match && (d[pos] & 0xf) == single)){
          struct Hash h = make_triple(g->n, to_char[match/0x11]);
          Vector_push(q, &h);
          pos = MD5_DIGEST_LENGTH;
          break;
        }
      }
    }
    for(int pos = 0; pos+2 < MD5_DIGEST_LENGTH; ++pos){
      unsigned char matchee1 = d[pos];
      unsigned char matchee2 = d[pos+1];
      unsigned char matchee3 = d[pos+2];
      for(unsigned char match = 0x00; match != 0x10; match += 0x11){
        unsigned single = match/0x11;
        if((matchee1 == match && matchee2 == match && (d[pos+2] >> 4) == single) ||
           (matchee2 == match && matchee3 == match && (d[pos] & 0xf) == single)){
          struct Hash h = make_quintuple(g->n, to_char[single]);
          Vector_push(q, &h);
        }
      }
    }
    ++g->n;
  }
}

static struct Hash get_hash(Vector q, int pos){
  return ((struct Hash*)Vector_data(q))[pos];
}

static struct Hash get_key(struct Generator *g, Vector q, int pos, int stretch){
    calculate_key(g, q, pos, stretch);
    return get_hash(q, pos);
}

int solve(int stretch){
  struct Generator g;
  Vector q = Vector_create(sizeof(struct Hash));
  char input[100];
  int pos = 0;
  int ans = 0;
  read_input(input);
  init_generator(&g, input);
  for(int k = 0; k < 64; ++k){
    int found_key = 0;
      do{
        struct Hash h = get_key(&g, q, pos++, stretch);
        if(h.t != -1){
          for(int x = pos; ; ++x){
            struct Hash f = get_key(&g, q, x, stretch);
            if(f.t == -1 && f.q == h.t && f.n != h.n){
              found_key = 1;
              ans = h.n;
              break;
            }
            if(f.n > h.n+1000) break;
          }
        }
      }while (!found_key);
  }
  return ans;
}

void part1(){
  printf("%d\n", solve(0));
}

void part2(){
  printf("%d\n", solve(2016));
}
