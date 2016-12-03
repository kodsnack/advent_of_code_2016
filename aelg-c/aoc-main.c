#include <stdio.h>

#include "aoc-main.h"

int main(int argc, char *argv[]){
  if (argc == 2){
    if(argv[1][0] == '1'){
      part1();
      return 0;
    } 
    else if(argv[1][0] == '2'){
      part2();
      return 0;
    } 
  }
  else {
    printf("What part?\n");
  }
  return 1;
}
