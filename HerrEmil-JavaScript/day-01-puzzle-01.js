const initialPosition = [0, 0];
const initialDirection = [1, 0];

function turn(direction, instruction) {
	let leftOrRight = instruction.charAt(0);

	if (leftOrRight == 'L') {
		temp = -direction[0];
		direction[0] = direction[1];
		direction[1] = temp;
	} else {
		temp = direction[0];
		direction[0] = -direction[1];
		direction[1] = temp;
	}
}


function move(position, direction, instruction) {
	let distance = instruction.substring(1, instruction.length);
	position[0] += direction[0] * distance;
	position[1] += direction[1] * distance;
}


function getManhattanDistance(position) {
	return Math.abs(position[0]) + Math.abs(position[1]);
}


function solve(input) {
	let instructions = input.split(', ');
	let direction = initialDirection.slice();
	let position = initialPosition.slice();

	for (let i = 0; i < instructions.length; i += 1) {
		turn(direction, instructions[i]);
		move(position, direction, instructions[i]);
	}

	return getManhattanDistance(position);
}


module.exports.solve = solve;
