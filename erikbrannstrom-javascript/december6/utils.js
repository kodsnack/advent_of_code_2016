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

exports.getCharArrays = (lines) => {
    return transpose(lines.map(line => line.split("")));
};
