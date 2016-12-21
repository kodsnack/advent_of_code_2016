from collections import deque

inputPath = "d19_input.txt"

def whoWins(players):
    lst = range(1, (players+1))
    i = 0
    while len(lst) > 2:
        while (i == 0) and (len(lst) > 2):
            if (len(lst) % 2) == 0:
                lst = lst[0:len(lst):2]
            if (len(lst) % 2) == 1:
                lst = lst[0:len(lst):2]
                i = len(lst) -1
        left = (i+1) % len(lst)
        lst.pop(left)
        if left >= len(lst):
            i = 0
        else:
            i = left
    return lst[i]

def whoWins2(players):
    lQ = deque(range(1, ((players//2) + 1)))
    rQ = deque(range(players, (players//2), -1))
    while (len(lQ) > 0) and (len(rQ) > 0):
        if len(lQ) > len(rQ):
            lQ.pop()
        else:
            rQ.pop()
        rQ.appendleft(lQ.popleft())
        lQ.append(rQ.pop())
    if len(lQ) > 0:
        return lQ.pop()
    else:
        return rQ.pop()


with open (inputPath, "r") as inputfile:
    input = inputfile.read().strip()

print "Part one: " + str(whoWins(int(input)))
print "Part two: " + str(whoWins2(int(input)))
