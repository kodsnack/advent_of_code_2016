
export class Row {
	private _keys: Key[];
	constructor(row: string) {
		this._keys = row.trim().split(/\s+/).map(key => new Key(true, key));
	}

	public pad(maxSize: number) {
		if (this.size < maxSize) {
			const padSize = (maxSize - this.size) / 2;

			for (let padding = 0; padding < padSize; padding++) {
				this._keys.unshift(new Key(false, ' '));
				this._keys.push(new Key(false, ' '));
			}
		}
	}

	public get size() { return this._keys.length; }
	public get keys() { return this._keys; }
}

class Key {
	constructor(public pressable: boolean, public value: string) { }
}
