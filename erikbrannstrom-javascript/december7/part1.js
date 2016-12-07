const fs = require("fs");

const ABBA_LENGTH = 4;

const isAbba = (str) => {
    return str[0] === str[3] && str[1] === str[2] && str[0] !== str[1];
};

const containsAbba = (str) => {
    if (str.length < ABBA_LENGTH) {
        return false;
    }

    let sequences = [];
    for (let i = 0; i <= str.length - ABBA_LENGTH; i++) {
        sequences.push(str.substring(i, i + ABBA_LENGTH));
    }

    return sequences.some(isAbba);
};

const hasTLSSupport = (ip) => {
    const hypernets = (ip.match(/\[[a-z]+\]/g) || []).map(hypernet => hypernet.replace(/[\[\]]/g, ""));
    const parts = hypernets.reduce((str, hypernet) => str.replace(`[${ hypernet }]`, "|"), ip).split("|");
    return parts.some(containsAbba) && !hypernets.some(containsAbba);
};

const getNumberOfIPsWithTLS = (ips) => {
    return ips.filter(hasTLSSupport).length;
};

const data = fs.readFileSync(process.argv[2], "utf8");
console.log(getNumberOfIPsWithTLS(data.split("\n")));
