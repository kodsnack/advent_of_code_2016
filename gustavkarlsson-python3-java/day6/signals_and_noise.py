""" Advent of Code 2016 - Day 6 - Signals and Noise """

import sys
from collections import Counter

def main():
    rows = [r.strip() for r in sys.stdin.readlines()]
    for col in range(8):
        letters = ''
        for r in rows:
            letters += r[col]    
        print(Counter(letters).most_common(1)[0][0], end='')

if __name__ == '__main__':
    main()
