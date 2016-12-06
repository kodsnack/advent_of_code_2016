#include "aoc-main.h"

#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include <string.h>

#define NUM_LETTERS (26)

struct Room{
  char name[100];
  int sector_id;
  char checksum[6];
};

struct Letter{
  char letter;
  int num;
};

typedef regex_t RL;

static RL readline_init(){
  const char *pattern = "([a-z-]+)-([0-9]+)\\[([a-z]{5})]";
  regex_t preg;
  regcomp(&preg, pattern, REG_EXTENDED);
  return preg;
}

static void readline_destroy(RL rl){
  regfree(&rl);
}

static struct Room readline(RL rl){
  char s[200];
  regmatch_t pmatch[4];
  struct Room room = {0};
  
  int res = scanf("%199s\n", s);
  if (res == EOF){
    return room;
  }

  regexec(&rl, s, 4, pmatch, 0);

  strncpy(room.name, s + pmatch[1].rm_so, pmatch[1].rm_eo - pmatch[1].rm_so);
  room.sector_id = atoi(s + pmatch[2].rm_so);
  strncpy(room.checksum, s + pmatch[3].rm_so, pmatch[3].rm_eo - pmatch[3].rm_so);

  return room;
}

static int to_index(char c){
  return c - 'a';
}

static int comp_letter(const void* p1, const void* p2){
  const struct Letter *lhs = p1;
  const struct Letter *rhs = p2;
  if(lhs->letter == 0) return 1;
  if(rhs->letter == 0) return -1;
  return -(lhs->num - rhs->num)*(NUM_LETTERS+1) + ((int)lhs->letter - (int)rhs->letter);
}

static void calc_checksum(const char *name, char *checksum){
  struct Letter letters[NUM_LETTERS] = {0};
  do{
    if(*name == '-') continue;
    struct Letter *letter = &letters[to_index(*name)];
    letter->letter = *name;
    ++letter->num;
  } while(*(++name));
  qsort(letters, NUM_LETTERS, sizeof(struct Letter), comp_letter);
  for(int i = 0; i < 5; ++i){
    checksum[i] = letters[i].letter;
  }
  checksum[5] = 0;
}

void part1(){
  int sum = 0;
  RL rl = readline_init();
  for(;;){
    char checksum[6];
    struct Room room = readline(rl);
    if(room.name[0] == 0) break;
    calc_checksum(room.name, checksum);
    if (strcmp(checksum, room.checksum) == 0){
      sum += room.sector_id;
    }
  }
  readline_destroy(rl);
  printf("%d\n", sum);
}

static void decrypt_room(struct Room *room){
  char *c = &room->name[0] - 1;
  while(*(++c)){
    if(*c == '-'){
      *c = ' ';
    }
    else{
      *c = (*c - 'a' + room->sector_id)%NUM_LETTERS + 'a';
    }
  }
}

void part2(){
  RL rl = readline_init();
  for(;;){
    char checksum[6];
    struct Room room = readline(rl);
    if(room.name[0] == 0) break;
    calc_checksum(room.name, checksum);
    if (strcmp(checksum, room.checksum) == 0){
      decrypt_room(&room);
      if(strstr(room.name, "north") && strstr(room.name, "storage")){
        printf("%d\n", room.sector_id);
      }
    }
  }
  readline_destroy(rl);
}
