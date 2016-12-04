let assert = require('assert');
let puzzle = require('./day-01-puzzle-02');

describe('Day 01, Puzzle 02 solution', function() {
	it('should be 4 given input "R8, R4, R4, R8"', function() {
		assert.equal(puzzle.solve('R8, R4, R4, R8'), 4);
	});
});
