const fs = require("fs");

const ABA_LENGTH = 3;

const isAba = (str) => {
    return str[0] === str[2] && str[0] !== str[1];
};

const getSequences = (str) => {
    if (str.length < ABA_LENGTH) {
        return false;
    }

    let sequences = [];
    for (let i = 0; i <= str.length - ABA_LENGTH; i++) {
        sequences.push(str.substring(i, i + ABA_LENGTH));
    }

    return sequences;
};

const flatten = arrays => arrays.reduce((flattenedArray, array) => flattenedArray.concat(array), []);
const hasSSLSupport = (ip) => {
    const hypernets = (ip.match(/\[[a-z]+\]/g) || []).map(hypernet => hypernet.replace(/[\[\]]/g, ""));
    const parts = hypernets.reduce((str, hypernet) => str.replace(`[${ hypernet }]`, "|"), ip).split("|");
    const abas = flatten(parts.map(getSequences)).filter(isAba);
    const babs = abas.map(aba => `${aba[1]}${aba[0]}${aba[1]}`);
    const hypernetSequences = flatten(hypernets.map(getSequences));
    return hypernetSequences.some(sequence => babs.indexOf(sequence) > -1);
};

const getNumberOfIPsWithSSL = (ips) => {
    return ips.filter(hasSSLSupport).length;
};

const data = fs.readFileSync(process.argv[2], "utf8");
console.log(getNumberOfIPsWithSSL(data.split("\n")));
