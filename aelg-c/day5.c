#include "aoc-main.h"

#include <stdio.h>
#include <string.h>
#include <openssl/md5.h>

static void int2string(char* s, int n, int len){
  s[len] = 0;
  while(len--){
    s[len] = n%10 + '0';
    n = n/10;
  }
}

void part1(){
  char input[100];
  unsigned char *d;
  char *end_of_id;
  int salt_len = 1;
  int id_len;
  int next_salt_len_increase = 10;
  int i = 0;

  scanf("%s", input);
  id_len = strlen(input);
  end_of_id = input + id_len;
  for(int k = 0; k < 8; ++k){
    for(;;){
      if(i == next_salt_len_increase) ++salt_len, next_salt_len_increase *= 10;
      int2string(end_of_id, i, salt_len);
      ++i;
      d = MD5((unsigned char*)input, id_len + salt_len, 0);
      if(d[0] == 0 && d[1] == 0 && (d[2]&0xf0) == 0){
        printf("%x", d[2]%0x10);
        break;
      }
    }
  }
  printf("\n");
}

void part2(){
  char input[100];
  unsigned char *d;
  char *end_of_id;
  int salt_len = 1;
  int id_len;
  int next_salt_len_increase = 10;
  int i = 0;
  char password[9] = {0};

  scanf("%s", input);
  id_len = strlen(input);
  end_of_id = input + id_len;
  fprintf(stderr, "********\r");

  for(;;){
    for(;;){
      if(i == next_salt_len_increase) ++salt_len, next_salt_len_increase *= 10;
      int2string(end_of_id, i, salt_len);
      ++i;
      d = MD5((unsigned char*)input, id_len + salt_len, 0);

      if(d[0] == 0 && d[1] == 0 && (d[2]&0xf0) == 0){
        int sixth = d[2]%0x10;
        int seventh = d[3] >> 4;
        if(sixth < 8 && password[sixth] == 0){
          if(seventh < 0xa) password[sixth] = seventh + '0';
          else password[sixth] = seventh - 0xa + 'a';
        }
        break;
      }
    }
    int done = 1;
    for(int k = 0; k < 8; ++k){
      fprintf(stderr, "%c", password[k] ? password[k] : '*');
      if(password[k] == 0) done = 0;
    }
    fprintf(stderr, "\r");
    if(done) break;
  }
  fprintf(stderr, "\n");
  printf("%s\n", password);
}
