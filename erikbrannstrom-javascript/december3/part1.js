const isTriangle = (sides) => {
    return sides[0] + sides[1] > sides[2]
        && sides[1] + sides[2] > sides[0]
        && sides[2] + sides[0] > sides[1];
};

const toInt = val => parseInt(val, 10);
const getValidTriangleCount = (triangles) => {
    const validTriangles = triangles
        .map(str => str.match(/[\d]+/g).map(toInt))
        .filter(isTriangle);
    return validTriangles.length;
};

console.log(getValidTriangleCount(process.argv[2].split("\n")));
