const fs = require('fs');

fs.readFile('day1.txt', 'utf8', function (err,data) {
  	if (err) {
    	return console.log(err);
  	}
  	var input = data.split(', ');
	
	//** Part 1 **//
	console.log(part1(input));

	//** Part 2 **//
	console.log(part2(input));
});
			//   N		E		S 		W
const compass = [[1,0], [0,1], [-1,0], [0,-1]];

function part1(input) {
	var direction = 0;
	var position = [0,0]
	for (var i = 0; i < input.length; i++) {
		var leftOrRight = input[i].substr(0,1);
		var distance = parseInt(input[i].substr(1));
		direction = turn(leftOrRight, direction);
		position[0] += compass[direction][0] * distance; 
		position[1] += compass[direction][1] * distance;	
	}
	return Math.abs(position[0]) + Math.abs(position[1]);
}

function part2(input) {
	var direction = 0;
	var position = [0,0]
	var trail = [[0,0]];
	for (var i = 0; i < input.length; i++) {
		var leftOrRight = input[i].substr(0,1);
		var distance = parseInt(input[i].substr(1));
		direction = turn(leftOrRight, direction);
		for (var j = 0; j < distance; j++) {
			position[0] += compass[direction][0];
			position[1] += compass[direction][1];
			if (trail.indexOfPosition(position) >= 0) {
				return Math.abs(position[0]) + Math.abs(position[1]);	
			}
			trail.push(position.slice(0));
		}
	}
	return trail;
}

function turn(b, d) {
	d += b == 'L' ? -1 : 1;
	d = d < 0 ? 3 : d;
	d = d > 3 ? 0 : d;
	return d;
}

Array.prototype.indexOfPosition = function(pos) {
    for (i = 0; i < this.length; i++) {
        if (pos[0] == this[i][0] && pos[1] == this[i][1]) {
        	return i;
        }
    }
    return -1;
};


