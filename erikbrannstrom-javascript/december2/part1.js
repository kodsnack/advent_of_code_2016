const Instructions = require("./Instructions");
const PAD = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
];

const initialPosition = { x: 1, y: 1 };
const instructionList = process.argv[2].split("\n");
console.log(Instructions.getCode(initialPosition, instructionList, PAD));
