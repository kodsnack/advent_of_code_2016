export class Instruction {
	private _direction:number;
	private _blocks:number;

	constructor(input: string){
		this._direction = (input.includes('L') ? -90 : 90);
		this._blocks = parseInt(/\d+/.exec(input)[0], 10);
	}

	public get direction() { return this._direction; }
	public get blocks() { return this._blocks; }

	toString(){
		return `Direction: ${this.direction}, Blocks: ${this.blocks}`;
	}
}