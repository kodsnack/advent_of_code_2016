#include "aoc-main.h"

#include <stdio.h>

void part1(){
  char input[200];
  int sum = 0;
  while(scanf("%s\n", input) == 1){
    int brackets = 0;
    int is_tls = 0;
    for(int i = 0; input[i]; ++i){
      if(input[i] == '[') ++brackets;
      else if(input[i] == ']') --brackets;
      else if(i > 2 && input[i] != input[i-1] && 
         input[i] && input[i-3] == input[i] && input[i-1] == input[i-2]){
        if(brackets == 0) is_tls = 1;
        else {
          is_tls = 0;
          break;
        }
      }
    }
    sum += is_tls;
  }
  printf("%d\n", sum);
}

void part2(){
  char input[200];
  int sum = 0;
  while(scanf("%s\n", input) == 1){
    int brackets = 0;
    int inHypernet[26][26] = {0};
    int inSupernet[26][26] = {0};
    for(int i = 0; input[i]; ++i){
      if(input[i] == '[') ++brackets;
      else if(input[i] == ']') --brackets;
      else if(i > 1 && input[i] == input[i-2] && input[i] != input[i-1] &&
              input[i-1] >= 'a' && input[i-1] <='z'){
        int a = input[i] - 'a';
        int b = input[i-1] - 'a';
        if(brackets){
          if(inSupernet[b][a]){
            ++sum;
            break;
          }
          else {
            inHypernet[a][b] = 1;
          }
        }
        else{
          if(inHypernet[b][a]){
            ++sum;
            break;
          }
          else {
            inSupernet[a][b] = 1;
          }
        }
      }
    }
  }
  printf("%d\n", sum);
}
