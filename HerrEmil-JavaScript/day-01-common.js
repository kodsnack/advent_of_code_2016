module.exports.turn = function(direction, instruction) {
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
};


module.exports.getManhattanDistance = function(position) {
	return Math.abs(position[0]) + Math.abs(position[1]);
};
