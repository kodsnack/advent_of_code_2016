const fs = require("fs");

const containsAbba = (texts) => {
    return texts.some((text) => {
        let prv = null;
        curr = null;
        for (let i = 0; i < (text.length - 2); i++) {
            prv = curr;
            curr = text[i];
            if (prv === curr) {
                continue;
            }
            if (prv === text[i+2] && curr === text[i+1]) {
                return true;
            }
        }
        return false;
    });
};

const splitLine = (line) => {
    const nets = [];
    const hypernets = [];
    let current = [];
    let chr;
    for (let i = 0; i < line.length; i++) {
        chr = line[i];
        if (chr === "[") {
            nets.push(current.join(""));
            current = [];
        } else if (chr === "]") {
            hypernets.push(current.join(""));
            current = [];
        } else {
            current.push(chr);
        }
    }
    if (current.length > 0) {
        nets.push(current.join(""));
    }
    return {
        nets,
        hypernets,
    }
};

const isSnoopable = (line) => {
    let { nets, hypernets } = splitLine(line);
    return containsAbba(nets) && !containsAbba(hypernets);
};

const countSnoopableIPs = (fileName) => {
    const lines = fs.readFileSync(`${__dirname}/${ fileName }`, "utf-8").split("\n");
    let sum = 0;
    lines.forEach((line) => {
        if (isSnoopable(line)) {
            console.log(line);
            sum++;
        }
    });
    return sum;
};

console.log(countSnoopableIPs("testInput.txt"));
console.log(countSnoopableIPs("input.txt"));