"""" Advent of Code 2016 - Day 7 - IPv7 """

def main():
    with open('input7.txt', 'r') as fh:
        ips = fh.readlines()

    good_ips = 0

    for ip in ips:

        in_hypernet = False
        abba_inside_hypernet = False
        abba_outside_hypernet = False
        counter = 0

        l = len(ip)

        for c in range(l - 3):
            a, b, c, d = ip[counter], ip[counter + 1], ip[counter + 2], ip[counter + 3]
            if a != b and c != d and a == d and b == c:
                if in_hypernet:
                    abba_inside_hypernet = True
                    break

                abba_outside_hypernet = True

            if c == '[':
                in_hypernet = True
            if c == ']':
                in_hypernet = False

            counter += 1

        if abba_outside_hypernet and not abba_inside_hypernet:
            good_ips += 1

    print(good_ips)


if __name__ == '__main__':
    main()
