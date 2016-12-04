import { Triangle, TriangleFactory } from './Triangle'
import { input } from './input'


export const Puzzle1 = TriangleFactory.make(input).filter(t => t.possible).length
export const Puzzle2 = TriangleFactory.make(input, 3).filter(t => t.possible).length