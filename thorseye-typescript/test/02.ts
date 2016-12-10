import * as assert from 'assert';
import * as mocha from 'mocha';

import { Keypad } from '../02/Keypad';
import { input, keypadPuzzle1, keypadPuzzle2 } from '../02/input';

describe('day 2', () => {

	describe('day 2, puzzle 1', () => {
		it('should get the code', done => {
			const result = new Keypad(keypadPuzzle1)
				.pressInstructions('5', `
					ULL
					RRDDD
					LURDL
					UUUUD
				`);
			assert.equal(result, '1985');
			done();
		});

		it('should be correct', done => {
			const result = new Keypad(keypadPuzzle1).pressInstructions('5', input);
			assert.equal(result, '18843');
			done();
		})

	});

	describe('day 2, puzzle 2', () => {
		it('should return the number of block to the first revisited intersection', done => {
			const result = new Keypad(keypadPuzzle2).pressInstructions('5', `
				ULL
				RRDDD
				LURDL
				UUUUD
			`);
			assert.equal(result, '5DB3');
			done();
		})

		it('should be correct', done => {
			const result = new Keypad(keypadPuzzle2).pressInstructions('5', input);
			assert.equal(result, '67BB9');
			done();
		})
	})
});