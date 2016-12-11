const fs = require("fs");

const createMatrix = (cols, rows) => {
    return Array(rows).fill(null).map(() => Array(cols).fill(false));
};

const range = function* (n) {
    for (let i = 0; i < n; i++ ) {
        yield i;
    }
};

const transpose = (matrix) => {
    const rows = matrix.length;
    const cols = matrix[0].length;
    return Array.from(range(cols)).map(col => Array.from(range(rows)).map(row => matrix[row][col]));
};

const rect = (matrix, cols, rows) => {
    return matrix.map((row, rowIndex) => {
        if (rowIndex >= rows) {
            return row;
        }
        return row.map((col, colIndex) => (colIndex >= cols) ? col : true);
    });
};

const rotateRow = (matrix, rowIndex, positions) => {
    const row = matrix[rowIndex];
    const newRow = row.map((item, index) => {
        let newIndex = (index - positions) % row.length;
        if (newIndex < 0) {
            newIndex = row.length + newIndex;
        }
        return row[newIndex];
    });
    return matrix.map((oldRow, index) => index === rowIndex ? newRow : oldRow);
};

const rotateColumn = (matrix, columnIndex, positions) => {
    return transpose(rotateRow(transpose(matrix), columnIndex, positions));
};

const regexRect = /rect (\d+)x(\d+)/;
const regexRotateRow = /rotate row y=(\d+) by (\d+)/;
const regexRotateColumn = /rotate column x=(\d+) by (\d+)/;
const toInt = val => parseInt(val, 10);
const applyFunction = (matrix, input) => {
    if (regexRect.test(input)) {
        const matches = input.match(regexRect);
        return rect(matrix, toInt(matches[1]), toInt(matches[2]));
    }

    if (regexRotateRow.test(input)) {
        const matches = input.match(regexRotateRow);
        return rotateRow(matrix, toInt(matches[1]), toInt(matches[2]));
    }

    if (regexRotateColumn.test(input)) {
        const matches = input.match(regexRotateColumn);
        return rotateColumn(matrix, toInt(matches[1]), toInt(matches[2]));
    }

    return matrix;
};

const toString = (matrix) => {
    return matrix.map(row => row.map(value => value ? "#" : " ").join("")).join("\n");
};

const screen = createMatrix(50, 6);
const intructions = fs.readFileSync(process.argv[2], "utf8");
const finalScreen = intructions.split("\n").reduce(applyFunction, screen);
console.log(toString(finalScreen));
console.log(finalScreen.reduce((array, row) => array.concat(row)).filter(val => val).length);
