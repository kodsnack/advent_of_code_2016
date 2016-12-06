const fs = require('fs');
const lines = fs.readFileSync('./day-3-input.txt').toString().split('\r\n');


let counters = {
    one: 0,
    two: 0,
    rows: 0,
};

let verticals = {
    one:   [],
    two:   [],
    three: []
};

function isTriangleFromArray(input) {
    return isTriangle(input[0], input[1], input[2]);
}

function isTriangle(a, b, c) {
    return a < b + c && b < a + c && c < a + b;
}

function resetVerticals() {
    verticals.one = [];
    verticals.two = [];
    verticals.three = [];
}

function run() {
  lines.forEach((line) => {
    let regex = /([0-9]+)[ ]*([0-9]+)[ ]*([0-9]+)/g;
    let sides = regex.exec(line);
    
    if (sides) {
        let a = parseInt(sides[1]);
        let b = parseInt(sides[2]);
        let c = parseInt(sides[3]);

        verticals.one.push(a);
        verticals.two.push(b);
        verticals.three.push(c);

        counters.rows++;

        counters.one = isTriangle(a, b, c) ? counters.one + 1 : counters.one;

        if (counters.rows % 3 === 0) {
            
            counters.two = isTriangleFromArray(verticals.one) ? counters.two + 1 : counters.two;
            counters.two = isTriangleFromArray(verticals.two) ? counters.two + 1 : counters.two;
            counters.two = isTriangleFromArray(verticals.three) ? counters.two + 1 : counters.two;

            resetVerticals();
            counters.rows = 0;
        }
    }
  });
}

function printResult() {
    console.log('Part one: ' + counters.one);
    console.log('Part two: ' + counters.two);
}

run();
printResult();