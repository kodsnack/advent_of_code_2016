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

const getAbas = (texts) => { // Must find all matches, even if they overlap
    let results = [];
    texts.forEach((text) => {
        for (let i = 0; i < text.length-2; i++) {
            if (text[i] === text[i+2] && text[i] !== text[i+1]) {
                results.push(text.substr(i, 3));
            }
        }
    });
    if (results.length === 0) {
        return false;
    }
    return results;
};

const hasBab = (abas, texts) => { // abas a list of aba sequences. Return true if any is contained here.
    let found = false;
    abas.forEach((aba) => {
        if (found) {
            return;
        }
        const bab = [aba[1],aba[0],aba[1]].join('');
        texts.forEach((text) => {
            if (found) {
                return;
            }
            if (text.indexOf(bab) !== -1) {
                found = true;
            }
        });
    });
    return found;  
};

const supportsSSL = (line) => {
    let { nets, hypernets } = splitLine(line);
    const aba = getAbas(nets);
    if (!aba) {
        return false;
    }
    return hasBab(aba, hypernets)
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

const countSSLIPs = (fileName) => {
    const lines = fs.readFileSync(`${__dirname}/${ fileName }`, "utf-8").split("\n");
    let sum = 0;
    lines.forEach((line) => {
        if (supportsSSL(line)) {
            console.log(line);
            sum++;
        }
    });
    return sum;
}

//console.log(countSnoopableIPs("testInput.txt"));
//console.log(countSnoopableIPs("input.txt"));
console.log(countSSLIPs("testInput2.txt"));
console.log(countSSLIPs("input.txt"));