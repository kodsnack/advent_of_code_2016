const isTriangle = (sides) => {
    return sides[0] + sides[1] > sides[2]
        && sides[1] + sides[2] > sides[0]
        && sides[2] + sides[0] > sides[1];
};

const toInt = val => parseInt(val, 10);
function* range(n) {
    for (let i = 0; i < n; i++ ) {
        yield i;
    }
}
const transpose = (matrix) => {
    const rows = matrix.length;
    const cols = matrix[0].length;
    return Array.from(range(cols)).map(col => Array.from(range(rows)).map(row => matrix[row][col]));
};
const getValidTriangleCount = (lines) => {
    const rows = lines
        .map(str => str.match(/[\d]+/g).map(toInt));
    return transpose(rows)
        .reduce((list, row) => list.concat(row))
        .reduce((triangles, item, index) => {
            if (index % 3 === 0) {
                return [...triangles, [item]];
            }
            const len = triangles.length;
            return [...triangles.slice(0, len - 1), triangles[len - 1].concat(item)];
        }, [])
        .filter(isTriangle)
        .length;
};

console.log(getValidTriangleCount(process.argv[2].split("\n")));
