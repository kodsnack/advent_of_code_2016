export class Triangle {
	private _possible: boolean

	constructor(private _sides: number[]) {
		this._possible = (
			_sides[0] + _sides[1] > _sides[2] &&
			_sides[0] + _sides[2] > _sides[1] &&
			_sides[1] + _sides[2] > _sides[0]
		)
	}

	public get possible() { return this._possible }
}

export class TriangleFactory {
	public static make(input: string, offset = 1): Triangle[] {
		let triangles: Triangle[] = []

		const sides = input
			.split(/\s+/)
			.filter(side => side && side.length)
			.map(side => parseInt(side, 10))

		let i = 0
		while (i < sides.length) {
			for (let col = 0; col < offset; col++) {
				triangles.push(new Triangle([
					sides[i + col],
					sides[i + col + offset],
					sides[i + col + offset * 2]
				]))
			}

			i += offset * 3
		}

		return triangles
	}
}