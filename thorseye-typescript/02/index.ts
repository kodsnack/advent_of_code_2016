import { input, keypadPuzzle1, keypadPuzzle2 } from './input';
import { Keypad } from './KeyPad';

const pad = new Keypad(keypadPuzzle1);
const pad2 = new Keypad(keypadPuzzle2);



export var Puzzle1 = pad.pressInstructions('5', input);
export var Puzzle2 = pad2.pressInstructions('5', input); 