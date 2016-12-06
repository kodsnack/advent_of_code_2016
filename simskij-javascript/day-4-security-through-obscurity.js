const fs = require('fs');
const lines = fs.readFileSync('./day-4-input.txt').toString().split('\r\n');

const regex = {
    lines: /^([a-z\-]+)\-(\d+)\[([a-z]+)\]$/,
    room: /^northpole/
};
const answers = {
    one: 0,
    two: undefined
};

function getFrequency(letters) {
    const frequency = {};
    letters.forEach(letter => frequency[letter] = frequency[letter] + 1 || 1);
    return frequency;
}

function decryptName(name, steps) {
    const decrypted = [];
    name.split('').forEach(letter => decrypted.push(shiftLetter(letter, steps)));

    return decrypted.join('');
}

function shiftLetter(letter, steps) {
    if (letter === '-') {
        return ' ';
    }
    else {
        const alphabet = 'abcdefghijklmnopqrstuvwxyz';
        const position = (alphabet.indexOf(letter) + steps) % alphabet.length;

        return alphabet[position];
    }

}

function getCheckSum(name) {

    const letters = name.replace(/\-/g, '').split('');
    const frequency = getFrequency(letters);
    const uniques = Array.from(new Set(letters));

    uniques.sort((a, b) => {
        return frequency[a] !== frequency[b]
            ? frequency[b] - frequency[a]
            : (a < b ? -1 : 1);
    });

    return uniques.join('').substring(0, 5);
}

function run() {
    lines.forEach((line) => {
        const input = line.match(regex.lines);
        if (input) {
            const name = input[1];
            const sector = parseInt(input[2]);
            const saidChecksum = input[3];
            const realChecksum = getCheckSum(name);

            if (saidChecksum === realChecksum) {
                answers.one = answers.one + parseInt(sector);
            }

            let realRoomName = decryptName(name, sector);
            if (regex.room.test(realRoomName)) {
                answers.two = answers.two || sector;
            }
        }

    });
}

function print() {
    console.log('Part 1: ' + answers.one);
    console.log('Part 2: ' + answers.two);
}

run()
print();