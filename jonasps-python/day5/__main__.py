import hashlib

puzzle_input = 'reyedfim'

# I should refactor this code, but it works

class FindPassword:
    def __init__(self, puzzle_input):
        self.password = ""
        self.password_part_two = {}
        self.puzzle_input = puzzle_input
        self.memory = ''
        self.counter = 0

    def break_lock(self):
        while len(self.password) < 8:
            m = hashlib.md5()
            m.update(self.puzzle_input + str(self.counter))
            self.memory = m.hexdigest()
            if self.memory.startswith('00000'):
                self.password += self.memory[5:6]
            if len(self.password) == 8:
                return self.password
            self.counter += 1

    def break_lock_part_two(self):
        self.password = ''
        self.counter = 0
        while len(self.password_part_two) < 8:
            m = hashlib.md5()
            m.update(self.puzzle_input + str(self.counter))
            self.memory = m.hexdigest()
            if self.memory.startswith('00000'):
                num = self.memory[5:6]
                try:
                    if int(num) < int(8):
                        if not str(self.memory[5:6]) in self.password_part_two:
                            self.password_part_two[self.memory[5:6]] = self.memory[6:7]

                except:ValueError

            if len(self.password_part_two) == 8:
                for i in range(8):
                    self.password += self.password_part_two[str(i)]
                return self.password
            self.counter += 1

haxxor = FindPassword(puzzle_input)

print(haxxor.break_lock())
print(haxxor.break_lock_part_two())