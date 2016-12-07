const fs = require('fs');
const lines = fs.readFileSync('./day-6-input.txt').toString().split('\r\n');

const strings = ['', '', '', '', '', '', '', ''];
const passwords = { one: '', two: '', };

function rearrangeLinesByIndex() {
  lines.forEach(line => line.split('').forEach((letter, index) => strings[index] += letter));
}

function sortByFrequency(text) {
  const frequency = [];
  const output = Array.from(new Set(text.split('')));

  text.split('').forEach(letter => {
    frequency[letter] = frequency[letter] + 1 || 1
  });

  output.sort((a, b) => {
    return frequency[a] !== frequency[b] ? frequency[b] - frequency[a] : (a < b ? -1 : 1)
  });

  return output;
}

function getPasswords() {
  strings.forEach((text) => {
    let sorted = sortByFrequency(text);
    passwords.one += sorted[0];
    passwords.two += sorted[sorted.length - 1];

  });
}

function printPasswords() {
  console.log('Part 1: ' + passwords.one);
  console.log('Part 1: ' + passwords.two);
}

function run() {
  rearrangeLinesByIndex();
  getPasswords();
  printPasswords();
}

run();



