def solve(n, inp):
    def dragon_curve(s):
        r = s + '0'
        for c in reversed(s):
            if c == '0':
                r += '1'
            else:
                r += '0'
        return r

    def checksum(s):
        if len(s) % 2 == 1:
            return s
        else:
            sub = ''
            for i in range(0, len(s) - 1, 2):
                if s[i] == s[i + 1]:
                    sub += '1'
                else:
                    sub += '0'
            return checksum(sub)
        
    s = inp
    while len(s) < n:
        s = dragon_curve(s)
    return checksum(s[:n])


[n, inp] = input().split()
print(solve(272, inp))
print(solve(35651584, inp))
