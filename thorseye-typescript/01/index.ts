
import { Instructions } from './input';
import { Walker } from './Walker';

// Do the walk
const walker = new Walker();
walker.walk(Instructions);

export var Puzzle1 = walker.distanceToLastInstruction();
export var Puzzle2 = walker.distanceToFirstRevisitedIntersection();