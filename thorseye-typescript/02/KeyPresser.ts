import { Row } from './Row';

export interface Position {
	row: number;
	col: number;
}
interface MoveMatrix {
	[direction: string]: Position;
}

export class KeyPresser {
	private _code: string = '';

	private moveMatrix: MoveMatrix = {
		U: { row: -1, col: 0 },
		D: { row: 1, col: 0 },
		L: { row: 0, col: -1 },
		R: { row: 0, col: 1 },
	}

	public press(dir: string, rows: Row[], pos: Position): Position {
		const move = (<Position>this.moveMatrix[dir]);
		const nextRowIdx = pos.row + move.row;
		const nextColIdx = pos.col + move.col;

		const nextRow = rows[nextRowIdx];
		const next = nextRow && nextRow.keys[nextColIdx];
		if (next && next.pressable) {
			pos.row = nextRowIdx;
			pos.col = nextColIdx;
		}
		return pos;
	}

	public remember(rows: Row[], pos: Position) {
		this._code += rows[pos.row].keys[pos.col].value;
	}

	public get code() { return this._code; }

}