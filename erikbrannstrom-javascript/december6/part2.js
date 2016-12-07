const { getCharArrays } = require("./utils");

const getLeastCommonChar = (array) => {
    const countMap = array.reduce((countMap, char) => {
        return countMap.set(char, (countMap.get(char) || 0) + 1);
    }, new Map());
    return Array.from(countMap.entries()).reduce((leastCommon, entry) => {
        if (entry[1] < leastCommon[1]) {
            return entry;
        }
        return leastCommon;
    })[0];
};

const getCorrectedMessage = (input) => {
    const charArrays = getCharArrays(input.split("\n"));
    return charArrays.map(getLeastCommonChar).join("");
};

console.log(getCorrectedMessage(process.argv[2]));
