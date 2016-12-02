let day1 = require('./day-01-common');


function move(position, direction, instruction, visited, repeated) {
	let distance = instruction.substring(1, instruction.length);
	let nextPosition = [];

	for (let i = 0; i < distance; i += 1) {
		nextPosition[0] = position[0] + direction[0];
		nextPosition[1] = position[1] + direction[1];

		for (let j = 0; j < visited.length; j += 1) {
			if (visited[j][0] == nextPosition[0] &&
				visited[j][1] == nextPosition[1]) {
				repeated.push([nextPosition[0], nextPosition[1]]);
			}
		}
		position[0] = nextPosition[0];
		position[1] = nextPosition[1];
		visited.push([position[0], position[1]]);
	}
}


function solve(input) {
	let instructions = input.split(', ');
	let direction = [1, 0];
	let position = [0, 0];
	let repeated = [];
	let visited = [];

	for (let i = 0; i < instructions.length; i += 1) {
		day1.turn(direction, instructions[i]);
		move(position, direction, instructions[i], visited, repeated);
	}

	return day1.getManhattanDistance(repeated[0]);
}

module.exports.solve = solve;
