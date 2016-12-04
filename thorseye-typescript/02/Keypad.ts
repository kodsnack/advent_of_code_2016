import { KeyPresser } from './KeyPresser';
import { Row }  from './Row';

export class Keypad {
	private size = 0;
	private rows: Row[] = [];

	constructor(grid: string) {
		const rows = grid.split('\n').filter(line => line && line.length);
		rows.forEach(row => this.addRow(row));
	}

	private addRow(row: string) {
		this.rows.push(new Row(row));
		this.size = Math.max(...this.rows.map(row => row.size));
		this.rows.forEach(row => row.pad(this.size));
	}

	public pressInstructions(startAtKey: string, instructions: string): string {
		const startRowIndex = this.rows.findIndex(row => row.keys.map(key => key.value).indexOf(startAtKey) > -1);
		const startColIndex = this.rows[startRowIndex].keys.findIndex(key => key.value == startAtKey);

		const presser = new KeyPresser();
		let newPos = { row: startRowIndex, col: startColIndex };

		const lines = instructions
			.split('\n')
			.map(line => line.trim())
			.filter(line => line && line.length);

		lines.forEach(line => {
			for (let c = 0; c < line.length; c++) {
				const char = line.charAt(c);
				newPos = presser.press(char, this.rows, newPos);
			}
			presser.remember(this.rows, newPos);
		});

		return presser.code;
	}

	public toString() {
		let str = ``;
		this.rows.forEach(row => {
			str += row.keys.map(key => key.value).join(' ')
			str += '\n';
		})
		return str;
	}
}
