import pickle
def main():
	print len(set(opt((1,1), None, 0)))

def opt(point, visited, steps):
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
		return []
	elif steps > 50:
		return visitList
	else:
		visitList.append(point)
		newList = pickle.loads(pickle.dumps((visitList)))
		up = opt((x, y-1), newList, steps+1)
		down = opt((x, y+1), newList, steps+1)
		left = opt((x-1, y), newList, steps+1)
		right = opt((x+1, y), newList, steps+1)
		

		print  
		return (visitList + up + down + left + right)


def isWall(coord):
	input=1352
	ones = 1 & bin(coord[0]*coord[0] + 3*coord[0] + 2*coord[0]*coord[1]+coord[1]+coord[1]*coord[1] + input).count('1')
	if ones == 1:
		return True
	else:
		return False

if __name__ == "__main__":
    main()