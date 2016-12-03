#include <stdio.h>
#include <string.h>

static struct Move{
  int dx;
  int dy;
} MOVE[4] = {
  {0, 1},
  {1, 0},
  {0, -1},
  {-1, 0}
};

static int abs(int n){
  return n > 0 ? n : -n;
}

static int readinput(char *input, int *length){
  scanf("%1s%d", input, length);
  return scanf(", ") != EOF;
}

static int newdir(int dir, char *input){
  return (dir + 4 + (input[0] == 'R' ? 1 : -1)) % 4;
}


int day1(){
  char input[2];
  int dir = 0;
  int length;
  int x = 0;
  int y = 0;
  while(readinput(input, &length)){
    dir = newdir(dir, input);
    x += MOVE[dir].dx * length;
    y += MOVE[dir].dy * length;
  }
  return abs(x) + abs(y);
}

#define SIZE  1000
int day2(){
  const int ORIGIN = SIZE/2;
  static int map[SIZE][SIZE];
  char input[2];
  int length;
  int dir = 0;
  int x = ORIGIN;
  int y = ORIGIN;
  
  memset(&map, 0, sizeof(map));
  map[x][y] = 1;
  while(readinput(input, &length)){
    dir = newdir(dir, input);
    for(int i = 0; i < length; ++i){
      x += MOVE[dir].dx;
      y += MOVE[dir].dy;
      if (x < 0 || y < 0 || x > SIZE-1 || y > SIZE -1){
        printf("Out of bounds.\n");
        return -1;
      }
      if(map[x][y]) {
        return abs(x-ORIGIN) + abs(y-ORIGIN);
      }
      map[x][y] = 1;
    }
  }
  return -1;
}

int main(int argc, char *argv[]){
  if (argc == 2){
    if(argv[1][0] == '1'){
      printf("%d\n", day1());
      return 0;
    }
    else if(argv[1][0] == '2'){
      printf("%d\n", day2());
      return 0;
    }
  }
  else {
    printf("What day?\n");
  }
  return 1;
}
