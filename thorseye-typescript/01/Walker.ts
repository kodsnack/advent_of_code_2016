import { Instruction } from './Instruction';

class Point {
	constructor(public x: number, public y: number) { }
	public toString() {
		return `[${this.x}, ${this.y}]`
	}
}

export class Walker {
	private position: Point;
	private firstRevisited: Point;
	private trail:Array<Point> = [];

	private move(steps, direction) {
		for(let i=0; i<steps; i++){
			switch (direction) {
				case 0:
					this.position.y += 1;
					break;
				case 90:
					this.position.x += 1;
					break;
				case 180:
					this.position.y -= 1;
					break;
				case 270:
					this.position.x -= 1;
					break;
			}

			let trailPoint = new Point(this.position.x, this.position.y);
			if (this.trail.some(pos => (pos.x == this.position.x && pos.y == this.position.y))){
				if (this.firstRevisited == null){
					this.firstRevisited = trailPoint;
				}
			}

			this.trail.push(trailPoint);
		}
	}

	public walk(instructions: Array<Instruction>): void {
		let currentDirection = 0;
		this.position = new Point(0,0);
		this.trail = [];

		for (let instruction of instructions) {
			currentDirection = (currentDirection + instruction.direction) % 360;
			if (currentDirection < 0)
				currentDirection += 360;

			this.move(instruction.blocks, currentDirection);
		}
	}

	public distance(position:Point): number {
		const distance = Math.abs(position.x) + Math.abs(position.y);
		return distance;
	}

	public distanceToLastInstruction():number {
		return this.distance(this.position);
	}

	public distanceToFirstRevisitedIntersection():number {
		return this.distance(this.firstRevisited);
	}
}