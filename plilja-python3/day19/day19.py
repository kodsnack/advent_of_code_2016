def step1(n):
    elves = [[i, 1] for i in range(1, n + 1)]
    while len(elves) > 1:
        for i in range(0, len(elves)):
            [nr, num_presents] = elves[i]
            if num_presents != 0:
                steal = (i + 1) % len(elves)
                [next_nr, next_num_presents] = elves[steal]
                elves[i] = [nr, num_presents + next_num_presents]
                elves[steal] = [next_nr, 0]

        elves = list(filter(lambda x: x[1] > 0, elves))

    [nr, _] = elves[0]
    return nr


def step2(n):
    elves = [[i, 1] for i in range(1, n + 1)]
    while len(elves) > 1:
        j = 0
        k = 0
        for i in range(0, len(elves)):
            [nr, num_presents] = elves[i]
            if num_presents != 0:
                steal = (i + k + (len(elves) - j) // 2) % len(elves)
                [next_nr, next_num_presents] = elves[steal]
                elves[i] = [nr, num_presents + next_num_presents]
                elves[steal] = [next_nr, 0]
                j += 1
                k += 1
            else:
                k -= 1

        elves = list(filter(lambda x: x[1] > 0, elves))

    [nr, _] = elves[0]
    return nr


n = int(input())
print(step1(n))
print(step2(n))
