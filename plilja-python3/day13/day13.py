def step1(n, target_x, target_y):
    queue = [(1, 1, 0)]
    visited = {(1, 1)}
    while queue:
        x, y, dist = queue[0]
        queue = queue[1:]

        if x == target_x and y == target_y:
            return dist

        for x2, y2 in neighbours(n, x, y):
            if (x2, y2) not in visited:
                visited |= {(x2, y2)}
                queue += [(x2, y2, dist + 1)]

    return float('inf')


def step2(n):
    queue = [(1, 1, 0)]
    visited = {(1, 1)}
    ans = 0
    while queue:
        x, y, dist = queue[0]
        queue = queue[1:]

        if dist > 50:
            return ans
        ans += 1

        for x2, y2 in neighbours(n, x, y):
            if (x2, y2) not in visited:
                visited |= {(x2, y2)}
                queue += [(x2, y2, dist + 1)]

    return ans


def neighbours(n, x, y):
    for x, y in [(x + 1, y), (x, y + 1), (x - 1, y), (x, y - 1)]:
        if x >= 0 and y >= 0 and is_open(n, x, y):
            yield (x, y)


def is_open(n, x, y):
    k = x * x + 3 * x + 2 * x * y + y + y * y + n
    count = 0
    while k != 0:
        count += k & 1
        k >>= 1
    return count % 2 == 0


n = int(input())
[x, y] = list(map(int, input().split()))
print(step1(n, x, y))
print(step2(n))
