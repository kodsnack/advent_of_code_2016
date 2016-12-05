var lineReader = require('readline').createInterface({
	input: require('fs').createReadStream('day2.txt')
});

const keypad1 = [[1,2,3],[4,5,6],[7,8,9]];
const keypad2 = [[,,,,,,],[,,,1,,,],[,,2,3,4,,],[,5,6,7,8,9,,],[,,'A','B','C',,],[,,,'D',,,],[,,,,,,]];

var target1 = [1,1];
var target2 = [1,3];

lineReader.on('line', function (line) {
	console.log("Puzzle1: " + getKeyStroke(line, target1, move1, keypad1) + " Puzzle2: " + getKeyStroke(line, target2, move2, keypad2));
});

function getKeyStroke(input, target, moveFunction, keypad) {
	var keyStroke = [];
	for (var i = 0; i < input.length; i++) {
		target = moveFunction(target, input[i], keypad);
	};
	
	return keypad[(target[1])][(target[0])];
}

function move1(t, cmd) {
	switch (cmd) {
		case 'U':
			return t[1] < 1 ? t : [t[0],t[1]-1];
		case 'D':
			return t[1] > 1 ? t : [t[0],t[1]+1];
		case 'L':
			return t[0] < 1 ? t : [t[0]-1,t[1]];
		case 'R':
			return t[0] > 1 ? t : [t[0]+1,t[1]];
		default:
			return t;
	}	
}

function move2(t, cmd, keypad) {
	switch (cmd) {
		case 'U':
			return keypad[(t[0])][(t[1]-1)] != undefined ? [t[0],t[1]-1] : t;
		case 'D':
			return keypad[(t[0])][(t[1]+1)] != undefined ? [t[0],t[1]+1] : t;
		case 'L':
			return keypad[(t[0]-1)][(t[1])] != undefined ? [t[0]-1,t[1]] : t;
		case 'R':
			return keypad[(t[0]+1)][(t[1])] != undefined ? [t[0]+1,t[1]] : t;
		default:
			return t;
	}	
}