import pickle
def main():
	print opt((31,39), None)

def opt(point, visited):
	x = point[0]
	y = point[1]
	if visited == None:
		visitList = []
	else: 
		visitList = visited

	visited = False
	if point in visitList:
		visited = True

	if x < 0 or y < 0 or x > 100 or y > 100 or visited or isWall((x,y)):
		return 99999999999
	elif x==1 and y==1:
		return 0
	else:
		visitList.append(point)
		newList = pickle.loads(pickle.dumps((visitList)))
		up = opt((x, y-1), newList)
		down = opt((x, y+1), newList)
		left = opt((x-1, y), newList)
		right = opt((x+1, y), newList)
		return 1 + min(up, down, left, right)


def isWall(coord):
	input=1352
	ones = 1 & bin(coord[0]*coord[0] + 3*coord[0] + 2*coord[0]*coord[1]+coord[1]+coord[1]*coord[1] + input).count('1')
	if ones == 1:
		return True
	else:
		return False

if __name__ == "__main__":
    main()