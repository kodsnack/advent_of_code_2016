const { Orientation, getInstruction, follow } = require("./Instructions");

const followInstructions = (initialPosition, instructions) => {
	return instructions.map(getInstruction).reduce(follow, initialPosition);
};

const countDistance = (instructions) => {
	const initialPosition = {
		x: 0,
		y: 0,
		orientation: Orientation.NORTH,
	};
	const finalPosition = followInstructions(initialPosition, instructions);
	return Math.abs(finalPosition.x) + Math.abs(finalPosition.y);
}

const input = process.argv[2];
console.log(countDistance(input.split(", ")));