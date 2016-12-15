from math import *
import sys


def annotations(n, ip):
    c = 0
    outside_brackets = []
    in_brackets = []

    for i in range(0, len(ip) - n):
        if ip[i] == '[':
            c += 1
        elif ip[i] == ']':
            c -= 1
        else:
            sub = ip[i:i + n]
            if '[' not in sub and ']' not in sub and sub[:ceil(n / 2)] == sub[-1:floor(-n / 2) - 1:-1] and sub[0] != \
                    sub[1]:
                if c == 0:
                    outside_brackets += [sub]
                else:
                    in_brackets += [sub]

    return (in_brackets, outside_brackets)


def step1(inp):
    ans = 0
    for in_brackets, outside_brackets in map(lambda x: annotations(4, x), inp):
        if not in_brackets and outside_brackets:
            ans += 1
    return ans


def step2(inp):
    ans = 0
    for in_brackets, outside_brackets in map(lambda x: annotations(3, x), inp):
        match = False
        for bab in outside_brackets:
            aba = bab[1] + bab[0] + bab[1]
            match = match or aba in in_brackets
        if match:
            ans += 1
    return ans


inp = sys.stdin.readlines()
print(step1(inp))
print(step2(inp))
