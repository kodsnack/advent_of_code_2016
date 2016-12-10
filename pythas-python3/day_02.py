def solve_part1(data):
	keypad = [
		["1", "2", "3"],
		["4", "5", "6"],
		["7", "8", "9"]
	]
	position = [1, 1]
	code = ""

	for directions in data.split("\n"):
		for direction in directions:
			if direction == 'U':
				position[1] = max(0, position[1] - 1)
			elif direction == 'R':
				position[0] = min(2, position[0] + 1)
			elif direction == 'D':
				position[1] = min(2, position[1] + 1)
			elif direction == 'L':
				position[0] = max(0, position[0] - 1)

		code += str(keypad[position[1]][position[0]])

	print(code)

def solve_part2(data):
	keypad = [
		["", "", "1", "", ""],
		["", "2", "3", "4", ""],
		["5", "6", "7", "8", "9"],
		["", "A", "B", "C", ""],
		["", "", "D", "", ""],
	]

	position = [0, 2]
	code = ""

	for directions in data.split("\n"):
		for direction in directions:
			prevPosition = position.copy()

			if direction == 'U':
				position[1] = max(0, position[1] - 1)
			elif direction == 'R':
				position[0] = min(4, position[0] + 1)
			elif direction == 'D':
				position[1] = min(4, position[1] + 1)
			elif direction == 'L':
				position[0] = max(0, position[0] - 1)

			if not keypad[position[1]][position[0]]:
				position = prevPosition

		code += str(keypad[position[1]][position[0]])

	print(code)


with open('data/02.txt', 'r') as file:
	data = file.read()

	solve_part1(data)
	solve_part2(data)