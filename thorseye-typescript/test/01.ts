import * as assert from 'assert';
import * as mocha from 'mocha';

import { Walker } from '../01/Walker';
import { generateInstructions, Instructions } from '../01/input';

describe('day 1', () => {

	let walker;
	beforeEach(done => {
		walker = new Walker();
		done();
	});

	describe('puzzle 1', () => {
		it('should get the number of blocks from head quarters', done => {
		
			walker.walk(generateInstructions('R2, L3'));
			assert.equal(walker.distanceToLastInstruction(), 5);

			walker.walk(generateInstructions('R2, R2, R2'));
			assert.equal(walker.distanceToLastInstruction(), 2);

			walker.walk(generateInstructions('R5, L5, R5, R3'));
			assert.equal(walker.distanceToLastInstruction(), 12);

			done();
		});

		it('should get the result of puzzle 1, day 1', done => {
			walker.walk(Instructions);
			assert.equal(walker.distanceToLastInstruction(), 300);
			
			done();
		});
	});

	describe('puzzle 2', () => {
		it('should return the number of block to the first revisited intersection', done => {
			walker.walk(generateInstructions('R8, R4, R4, R8'))
			assert.equal(walker.distanceToFirstRevisitedIntersection(), 4);

			done();
		});

		it('should return the number of block to the first revisited intersection', done => {
			walker.walk(Instructions)
			assert.equal(walker.distanceToFirstRevisitedIntersection(), 159);
			
			done();
		})
	})
});