# /usr/bin/
# Viktor Ceder, Advent of Code 2016


class Display:
    def __init__(self, width=50, height=6):
        self.width = int(width)
        self.height = int(height)
        self.matrix = []
        for i in range(height):
            self.matrix.append(['.']*width)

    def rect(self, x, y):
        for i in range(y):
            for j in range(x):
                self.matrix[i][j]='*'


    def __countLit(self, x='', y=''):
        counter = 0
        if x == '' and y == '':
            for row in self.matrix:
                for col in row:
                    if col =='*':
                        counter += 1
            return counter
        elif x != '' and y == '':
            for col in self.matrix[x]:
                if col == '*':
                    counter += 1
            return counter
        elif x =='' and y != '':
            for row in self.matrix:
                if row[y] == '*':
                    counter += 1
            return counter
        elif x != '' and y != '':
            if self.matrix[x][y]:
                return 1
        else:
            return 0

    def rotateColumn(self, column, steps):
        toBeMoved = self.__countLit(y=column)
        move =[]
        #for step in range(steps):
        for row in range(self.height):
            if toBeMoved > 0:
                if self.matrix[row][column] == '.':
                    pass
                else:
                    move.append(row)
                    self.matrix[row][column] = '.'
                    toBeMoved -= 1
        for i in move:
            try:
                self.matrix[i+steps][column]='*'
            except IndexError:
                newStep = i + steps - self.height
                self.matrix[newStep][column]='*'

    def rotateRow(self, row, steps):
        toBeMoved = self.__countLit(x=row)
        move=[]
        for column in range(self.width):
            if toBeMoved > 0:
                if self.matrix[row][column] == '*':
                    move.append(column)
                    self.matrix[row][column] = '.'
                    toBeMoved -= 1
        for i in move:
            try:
                self.matrix[row][i+steps] = '*'
            except IndexError:
                newStep = i + steps - self.width
                self.matrix[row][newStep]='*'

    def draw(self):
        out = ''
        for row in self.matrix:
            out += ''.join(row)
            out += '\n'
        print(out, end='\n')#'\r' for update in place
    def lit(self):
        return self.__countLit()

def main():
    d = Display()

    # d.rect(3,2)
    # d.draw()
    # d.rotateColumn(2,8)
    # d.draw()
    # d.rotateRow(0, 51)
    # d.draw()
    #print(d.lit())
pass


if __name__ == '__main__':
    main()
