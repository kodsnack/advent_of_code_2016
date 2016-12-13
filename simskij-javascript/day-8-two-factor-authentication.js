const fs = require('fs');
const lines = fs.readFileSync('./day-8-input.txt').toString().split('\r\n');

let screen;

function togglePixels(x, y) {
  for (row = 0; row < y; row++) {
    for (cell = 0; cell < x; cell++) {
      screen[row][cell] = !screen[row][cell];
    }
  }
}

function rotateCol(index, amount) {
  for (count = 0; count < amount; count++) {
    first = screen[5][index];
    for (i = 5; i >= 0; i--) {
      screen[i][index] = screen[i - 1] ? screen[i - 1][index] : first;
    }
  }
}

function rotateRow(index, amount) {
  for (count = 0; count < amount; count++) {
    first = screen[index][49];
    for (i = 49; i >= 0; i--) {
      screen[index][i] = i - 1 >= 0 ? screen[index][i - 1] : first;
    }
  }
}

function run() {
  screen = Array(6).fill().map(() => Array(50).fill(false));
  lines.forEach((line, index) => {
    if ((match = /^rect ([0-9]+)x([0-9]+)/g.exec(line))) {
      togglePixels(match[1], match[2]);
    }
    else if ((match = /^rotate (row|column) .=([0-9]+) by ([0-9]+)/g.exec(line))) {
      if (match[1] === 'row') 
        rotateRow(match[2], match[3]);
      else if (match[1] === 'column')
        rotateCol(match[2], match[3]);
    }
  });
  
}

function print() {
  let output = screen.reduce((prev, next) => prev + next.reduce((line, col) => line + (col ? '#' : ' '), '') + '\n', '');
  let count = output.split('').filter(letter => letter === '#').length;

  console.log(`Part 1: ${count}`);
  console.log(`Part 2:\n${output}`);
}


run();
print();
