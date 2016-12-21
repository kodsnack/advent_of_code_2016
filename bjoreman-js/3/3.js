const input = require("./input");
console.log(input.day1.length, input.day2.length);
const possibleTriangle = (input) => {
    return input[0] + input[1] > input[2]
        && input[1] + input[2] > input[0]
        && input[2] + input[0] > input[1];
};
console.log(input.day1.map(possibleTriangle).reduce((sum, val) =>  val ? sum +1 : sum, 0));
console.log(input.day2.map(possibleTriangle).reduce((sum, val) =>  val ? sum +1 : sum, 0));