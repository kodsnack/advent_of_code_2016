const { getCharArrays } = require("./utils");

const getMostCommonChar = (array) => {
    const countMap = array.reduce((countMap, char) => {
        return countMap.set(char, (countMap.get(char) || 0) + 1);
    }, new Map());
    return Array.from(countMap.entries()).reduce((mostCommon, entry) => {
        if (entry[1] > mostCommon[1]) {
            return entry;
        }
        return mostCommon;
    })[0];
};

const getCorrectedMessage = (input) => {
    const charArrays = getCharArrays(input.split("\n"));
    return charArrays.map(getMostCommonChar).join("");
};

console.log(getCorrectedMessage(process.argv[2]));
