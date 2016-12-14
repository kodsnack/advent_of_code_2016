import re
import sys
from collections import namedtuple

Marker = namedtuple('Marker', 'chars repeat')

marker_re = re.compile('\(\d+x\d+\)')

def parse_marker(marker_text):
    without_parens = marker_text[1:-1]
    [chars, repeat] = list(map(int, without_parens.split('x')))
    return Marker(chars, repeat)

def step1(s):
    m = marker_re.search(s)
    if not m:
        return len(s)
    else:
        i = m.start()
        j = m.end()
        marker = parse_marker(s[i:j])
        return i + marker.chars * marker.repeat + step1(s[j + marker.chars:])

def step2(s):
    m = marker_re.search(s)
    if not m:
        return len(s)
    else:
        i = m.start()
        j = m.end()
        marker = parse_marker(s[i:j])
        sub = s[j:j + marker.chars]
        return i + step2(sub) * marker.repeat + step2(s[j + marker.chars:])

inp = input().strip()
print(step1(inp))
print(step2(inp))
