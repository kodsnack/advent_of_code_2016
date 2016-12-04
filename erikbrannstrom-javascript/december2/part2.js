const Instructions = require("./Instructions");
const PAD = [
    [null, null, 1, null, null],
    [null, 2, 3, 4, null],
    [5, 6, 7, 8, 9],
    [null, "A", "B", "C", null],
    [null, null, "D", null, null],
];

const initialPosition = { x: 0, y: 3 };
const instructionList = process.argv[2].split("\n");
console.log(Instructions.getCode(initialPosition, instructionList, PAD));
