import re
import sys


value_delegate = re.compile(r'value (\d+) goes to bot (\d+)')
bot_delegate = re.compile(r'bot (\d+) gives low to \b(bot|output) (\d+) and high to \b(bot|output) (\d+)')


def delegate(pinput, x, y):
    bots = dict()
    outputs = dict()
    for l in pinput:
        if value_delegate.match(l):
            fv, b = map(int, value_delegate.match(l).groups())
            bots[b] = bots[b] + [fv] if b in bots else [fv]

    bot = ''
    go = True
    while go:
        botz = bots.copy().items()
        for bid, bvs in botz:
            if len(bvs) == 2:
                for l in pinput:
                    if l.startswith('bot %d ' % bid) and bot_delegate.match(l):
                        fv, l, li, h, hi = bot_delegate.match(l).groups()
                        fv, li, hi = map(int, (fv, li, hi))
                        try:
                            if l == 'output':
                                outputs[li] = outputs[li] + [min(bots[fv])] if li in outputs else [min(bots[fv])]
                                bots[fv] = list(filter(lambda x: x != min(bots[fv]), bots[fv]))
                            else:
                                bots[li] = bots[li] + [min(bots[fv])] if li in bots else [min(bots[fv])]
                                bots[fv] = list(filter(lambda x: x != min(bots[fv]), bots[fv]))

                            if h == 'output':
                                outputs[hi] = outputs[hi] + [max(bots[fv])] if hi in outputs else [max(bots[fv])]
                                bots[fv] = list(filter(lambda x: x != max(bots[fv]), bots[fv]))
                            else:
                                bots[hi] = bots[hi] + [max(bots[fv])] if hi in bots else [max(bots[fv])]
                                bots[fv] = list(filter(lambda x: x != max(bots[fv]), bots[fv]))
                        except ValueError:
                            pass
                        break
        go = len(list(filter(lambda b: len(b[1]) == 2, bots.items()))) != 0
        bt = ''.join([str(z[0]) for z in filter(lambda z: x in z[1] and y in z[1], bots.items())])
        if len(bt) > 0:
            bot = bt
    return bot, outputs[0][0] * outputs[2][0] * outputs[1][0]


def run(pinput):
    """Day 10: Balance Bots"""
    bot, m = delegate(pinput.strip().splitlines(), 61, 17)

    print('Bot that deals with %s and %s:          %s' % (61, 17, bot))
    print('Multiple the values of 0-2:             %s' % m)

if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
