def solve(data):
	currentPosition = [0, 0]
	currentDirection = 0
	history = []
	hq = None

	for movement in data.split(', '):
		direction = movement[:1]
		distance = int(movement[1:])

		if direction == 'R':
			currentDirection = (currentDirection + 1) % 4
		elif direction == 'L':
			currentDirection = currentDirection - 1

			if currentDirection < 0:
				currentDirection = 3

		for i in range(distance):
			if currentDirection == 0:
				currentPosition[1] -= 1
			elif currentDirection == 1:
				currentPosition[0] += 1
			elif currentDirection == 2:
				currentPosition[1] += 1
			elif currentDirection == 3:
				currentPosition[0] -= 1

			if not hq:
				if currentPosition in history:
					hq = currentPosition.copy()
				else:
					history.append(currentPosition.copy())

	print(str(abs(currentPosition[0]) + abs(currentPosition[1])))
	print(str(abs(hq[0]) + abs(hq[1])))

with open('data/01.txt', 'r') as file:
	solve(file.read())