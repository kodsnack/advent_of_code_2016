const fs = require("fs");
const parse = (isDay1) => {
    const data = fs.readFileSync(`${__dirname}/input.txt`, "utf-8").split("\n").map((row) => {
        return [parseInt(row.substr(0,5).trim(),10), parseInt(row.substr(5,5).trim(),10), parseInt(row.substr(10).trim(), 10)];
    });
    if (!isDay1) {
        const columns = [0, 1, 2].map((index) => {
            return data.map((row) => row[index]);
        }).reduce((a, b) => a.concat(b), []);
        return columns.map((val, index) => {
            return (index % 3 === 0) ? columns.slice(index, index + 3) : null;
        }).filter((col) => col !== null);
    }
    return data;
};

module.exports = { day1: parse(true), day2: parse(false) };