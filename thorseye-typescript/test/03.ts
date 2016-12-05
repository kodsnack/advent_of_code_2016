import * as assert from 'assert'
import * as mocha from 'mocha'

import { Triangle, TriangleFactory } from '../03/Triangle'
import { input } from '../03/input'
import { Puzzle1 } from '../03'

describe('day 3', () => {

	describe('day 3, puzzle 1', () => {
		it('should create triangles by row', done => {
			const triangles = TriangleFactory.make(`
				5  5  5
				10 10 10
				20 20 20	
			`)

			assert.equal(triangles.every(t => t.possible), true);

			done()
		})
		it('should create triangles by column', done => {
			const triangles = TriangleFactory.make(`
				5 10 20
				5 10 20
				5 10 20	
			`, 3)

			assert.equal(triangles.every(t => t.possible), true);

			done()
		})

		it('should check if the triangle is possible', done => {
			assert.equal(new Triangle([5, 5, 5]).possible, true)
			assert.equal(new Triangle([5, 5, 10]).possible, false)

			done()
		})

		it('should be correct', done => {
			const result = Puzzle1
			console.log(result)
			// assert.equal(result, '18843');
			done()
		})

	})
})