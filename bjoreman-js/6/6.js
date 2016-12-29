const fs = require("fs");

const findMostCommon = (freq) => {
    let highest = {char: "", num: 0};
    freq.forEach((value, key) => {
        if (value > highest.num) {
            highest.char = key;
            highest.num = value;
        }
    });
    return highest.char;
};

const findLeastCommon = (freq) => {
    let lowest;
    freq.forEach((value, key) => {
        if (!lowest) {
            lowest = { char: key, num: value };
        } else {
            if (value < lowest.num) {
                lowest.char = key;
                lowest.num = value;
            }
        }
    });
    return lowest.char;
};

const descramble = (filename, leastCommon = false) => {
    const input = fs.readFileSync(`${__dirname}/${ filename }`, "utf-8").split("\n");
    const result = [];
    const len = input[0].length;
    for (let i = 0; i < len; i++) {
        const freq = new Map();
        input.forEach((line) => {
            const chr = line[i];
            if(freq.get(chr)) {
                freq.set(chr, freq.get(chr) + 1);
            } else {
                freq.set(chr, 1);
            }
        });
        result.push(leastCommon ? findLeastCommon(freq) : findMostCommon(freq));
    }
    return result.join('');
}

console.log(descramble("testInput.txt"));
console.log(descramble("input.txt"));
console.log(descramble("testInput.txt", true));
console.log(descramble("input.txt", true));