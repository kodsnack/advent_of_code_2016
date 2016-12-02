let assert = require('assert');
let puzzle = require('./day-01-puzzle-01');

describe('Day 01, Puzzle 01 solution', function() {
	it('should be 5 given input "R2, L3"', function() {
		assert.equal(puzzle.solve('R2, L3'), 5);
	});

	it('should be 2 given input "R2, R2, R2"', function() {
		assert.equal(puzzle.solve('R2, R2, R2'), 2);
	});

	it('should be 12 given input "R5, L5, R5, R3"', function() {
		assert.equal(puzzle.solve('R5, L5, R5, R3'), 12);
	});
});
