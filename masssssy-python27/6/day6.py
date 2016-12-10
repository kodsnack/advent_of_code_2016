import re
import collections

def main():
    inputfile = open("input")
    inputdata = inputfile.read()
    inputfile.close()

    splitData = inputdata.split("\n")

    columns = []
    for y in range (0,8):
        column = []
        for x in range(0, len(splitData)):
            column.append(splitData[x][y])
            column2 = ''.join(column)
        columns.append(column2)

    print "Most common"
    for b in range (0,8):
        print(collections.Counter(columns[b]).most_common(1)[0])

    print "Least common"
    for b in range (0,8):
        a = collections.Counter(columns[b]).most_common()[-1]
        print a

if __name__ == "__main__":
    main()