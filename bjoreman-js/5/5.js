const crypto = require('crypto');

const input = "reyedfim";
const test = "abc";
const password = [];

const md5 = (input) => {
    return crypto.createHash("md5").update(input).digest("hex");
};

const isInteresting = (input) => {
    return input.indexOf("00000") === 0;
};

const part1 = (inData) => {
    let i = 0;
    while (password.length < 8) {
        let hash = md5(inData + i);
        if (isInteresting(hash)) {
            password.push(hash[5]);
            console.log(password, i);
        }
        i++;
    }
    console.log(password.join(""));
};

const part2 = (inData) => {
    let i = 0;
    while (true) {
        let hash = md5(inData + i);
        if (isInteresting(hash)) {
            let pos = parseInt(hash[5], 10);
            if (pos > -1 && pos < 8 && !password[pos]) {
                password[pos] = hash[6];
                console.log(password, i);
                if (password.join("").length === 8) {
                    break;
                }
            }
        }
        i++;
    }
    console.log(password.join(""));
};

part2(input);