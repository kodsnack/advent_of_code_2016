const fs = require('fs');
const lines = fs.readFileSync('./day-7-input.txt').toString().split('\r\n');

const counters = { tls: 0, ssl: 0 };

function containsAbba(text) {
  for (i = 0; i < text.length - 3; i++) {
    if (text[i] === text[i + 3] && text[i + 1] === text[i + 2] && text[i] !== text[i + 1]) {
      return true;
    }
  }
  return false;
}

function getAbas(text) {
  let output = [];
  for (i = 0; i < text.length - 2; i++) {
    if (text[i] === text[i + 2] && text[i] !== text[i + 1]) {
      output.push(text.substring(i, i + 3));
    }
  }
  return output;
}

function run() {
  lines.forEach(line => {

    const hypernets = line
      .match(/\[[a-z]+\]/g || [])
      .map(hypernet => hypernet.replace(/[\[\]]/g, ''));
    
    const supernets = hypernets
      .reduce((text, hypernet) => text.replace('[' + hypernet + ']', ','), line)
      .split(',');

    const abba = { inside: false, outside: false, };

    let abas = [];
    let babs = [];

    hypernets.forEach((hypernet) => {
      babs = babs.concat(getAbas(hypernet));
      abba.inside = containsAbba(hypernet) ? true : abba.inside;
    });
    supernets.forEach(supernet => {
      abas = abas.concat(getAbas(supernet));
      abba.outside = containsAbba(supernet) ? true : abba.outside;
    });

    let isSSL = abas.filter(aba => babs.indexOf(aba[1] + aba[0] + aba[1]) !== -1).length > 0;

    counters.ssl = isSSL ? counters.ssl + 1 : counters.ssl;
    counters.tls = abba.outside && !abba.inside ? counters.tls + 1 : counters.tls;
  });
}


function print() {
  console.log(`Part 1: ${counters.tls}`);
  console.log(`Part 2: ${counters.ssl}`);
}

run();
print();