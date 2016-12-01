const { Orientation, follow, turn, move, getInstruction } = require("./Instructions");

const getAllVisitedPositions = (initialPosition, instructions) => {
	return instructions.map(getInstruction).reduce((list, instruction) => {
		const turnedPosition = turn(list[list.length - 1], instruction.turn);

		let travelledPositions = [];
		for (let i = 0; i < Math.abs(instruction.steps); i++) {
			const previousPosition = i === 0 ? turnedPosition : travelledPositions[i - 1];
			travelledPositions = travelledPositions.concat(move(previousPosition, 1));
		}

		return list.concat(travelledPositions);
	}, [initialPosition]);
};

const findFirstDuplicatePosition = (instructions) => {
	const initialPosition = {
		x: 0,
		y: 0,
		orientation: Orientation.NORTH,
	};

	const positions = getAllVisitedPositions(initialPosition, instructions);
	return positions.find((position, index) => {
		const previousPositions = positions.slice(0, index);
		return previousPositions.some(previousPosition => previousPosition.x === position.x && previousPosition.y === position.y);
	});
};

const countDistanceToPosition = (position) => {
	return Math.abs(position.x) + Math.abs(position.y);
}

const input = process.argv[2];
console.log(countDistanceToPosition(findFirstDuplicatePosition(input.split(", "))));