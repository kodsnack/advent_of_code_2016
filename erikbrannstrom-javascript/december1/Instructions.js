const Orientation = {
	NORTH: { x: 0, y: 1 },
	SOUTH: { x: 0, y: -1 },
	EAST: { x: 1, y: 0 },
	WEST: { x: -1, y: 0 },
};
const Instruction = {
	LEFT: 0,
	RIGHT: 1,
};

const turn = (currentPosition, instruction) => {
	const orientations = [Orientation.NORTH, Orientation.EAST, Orientation.SOUTH, Orientation.WEST];
	const orientationIndex = orientations.indexOf(currentPosition.orientation);
	const delta = instruction === Instruction.RIGHT ? 1 : -1;
	let newOrientationIndex = orientationIndex + delta;
	newOrientationIndex = newOrientationIndex < 0
		? newOrientationIndex + orientations.length
		: newOrientationIndex % orientations.length;
	return Object.assign({}, currentPosition, {
		orientation: orientations[newOrientationIndex],
	});
};

const move = (currentPosition, steps) => {
	return Object.assign({}, currentPosition, {
		x: currentPosition.x + steps * currentPosition.orientation.x,
		y: currentPosition.y + steps * currentPosition.orientation.y,
	});
};

const getInstruction = (input) => {
	const turnDirection = input.substring(0, 1);
	const turn = turnDirection.toUpperCase() === "L" ? Instruction.LEFT : Instruction.RIGHT;
	const steps = parseInt(input.substring(1), 10);
	return { turn, steps };
};

const follow = (currentPosition, instruction) => {
	return move(turn(currentPosition, instruction.turn), instruction.steps);
};

module.exports = { Orientation, move, turn, follow, getInstruction };