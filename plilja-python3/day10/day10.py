from collections import *
import sys


def solve(inp):
    value_to_bot = {}
    bot_to_values = defaultdict(set)
    outputs = defaultdict(list)
    giveaways = []
    Giveaway = namedtuple('Giveaway', 'bot low_to low_type high_to high_type')

    for s in inp:
        instruction = s.split()
        if instruction[0] == 'value':
            value = int(instruction[1])
            bot = int(instruction[5])
            bot_to_values[bot] |= {value}
            value_to_bot[value] = bot
        else:
            assert instruction[0] == 'bot'
            bot = int(instruction[1])
            low_type = instruction[5]
            low_to = int(instruction[6])
            high_type = instruction[10]
            high_to = int(instruction[11])
            giveaways += [(bot, Giveaway(bot, low_to, low_type, high_to, high_type))]

    while giveaways:
        if 61 in value_to_bot and 17 in value_to_bot and value_to_bot[61] == value_to_bot[17]:
            step1 = value_to_bot[61]
        for i in range(0, len(giveaways)):
            (bot, giveaway) = giveaways[i]
            if len(bot_to_values[bot]) == 2:
                low = min(bot_to_values[bot])
                high = max(bot_to_values[bot])
                bot_to_values[bot] -= {low, high}
                value_to_bot.pop(low)
                value_to_bot.pop(high)
                if giveaway.low_type == 'bot':
                    bot_to_values[giveaway.low_to] |= {low}
                    value_to_bot[low] = giveaway.low_to
                else:
                    outputs[giveaway.low_to] += [low]
                if giveaway.high_type == 'bot':
                    bot_to_values[giveaway.high_to] |= {high}
                    value_to_bot[high] = giveaway.high_to
                else:
                    outputs[giveaway.high_to] += [high]

                giveaways = giveaways[:i] + giveaways[i + 1:]
                break

    step2 = outputs[0][0] * outputs[1][0] * outputs[2][0]
    return (step1, step2)


inp = sys.stdin.readlines()
(step1, step2) = solve(inp)
print(step1)
print(step2)
