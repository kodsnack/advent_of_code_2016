const md5 = require('md5-jkmyers');
const input = 'reyedfim';

let password = { one: '', two: [, , , , , , , ,] };
let counter = 0;

function handleForPartOne(match) {
    if (password.one.length < 8) {
        password.one = password.one + match[1];
        console.log('[1] ' + password.one);
    }
}

function handleForPartTwo(match, hash) {
    if (parseInt(match[1]) >= 0 && parseInt(match[1]) < 8) {
        if (!password.two[match[1]]) {
            password.two[match[1]] = hash.toString(16).substring(6, 7);
            console.log('[2] ' + password.two.join(''));
        }
    }
}

function print() {
    console.log(`Part 1: ${password.one}`);
    console.log(`Part 2: ${password.two.join('')}`);
}

function run() {
    while (password.one.length < 8 || password.two.join('').length < 8) {
        let regex;
        let challenge = input + counter;
        let hash = md5(challenge);
        regex = new RegExp('^00000(.)');

        let match = hash.toString(16).match(regex);
        if (match) {
            handleForPartOne(match);
            handleForPartTwo(match, hash);
        }
        counter++;
    }
    print();
}

run();