import re
import sys


def count_ips(pinput):
    def tls(l):
        a = re.sub(r'\[.+?\]', lambda x: ' ', l)
        abbas = sum(map(lambda i: a[i:i + 4] == a[i:i + 4][::-1] and a[i:i + 1] != a[i + 1:i + 2],
                        range(0, len(a) - 3)))
        total = sum(map(lambda i: l[i:i + 4] == l[i:i + 4][::-1] and l[i:i + 1] != l[i + 1:i + 2],
                        range(0, len(l) - 3)))
        return abbas == total and abbas > 0

    def ssl(l):
        a = re.sub(r'\[.+?\]', lambda x: ' ', l)
        b = ' '.join(re.findall(r'\[(.+?)\]', l))

        abas = list(filter(lambda v: v, map(
            lambda i: a[i:i + 3] if a[i:i + 3] == a[i:i + 3][::-1] and a[i:i + 1] != a[i + 1:i + 2] else None,
            range(0, len(a) - 2))))
        babs = set(filter(lambda v: v, map(
            lambda i: b[i + 1:i + 3] + b[i + 1] if b[i:i + 3] == b[i:i + 3][::-1] and b[i:i + 1] != b[i + 1:i + 2] else None,
            range(0, len(b) - 2))))
        return len(set(abas).intersection(babs)) > 0

    return sum(map(tls, pinput.split('\n'))), sum(map(ssl, pinput.split('\n')))


def run(pinput):
    """Day 7: Internet Protocol Version 7"""
    tls, ssl = count_ips(pinput)

    print('IPs supporting TLS:                     %s' % tls)
    print('IPs supporting SSL:                     %s' % ssl)


if __name__ == '__main__':
    try:
        with open(sys.argv[1], 'r') as f:
            run(f.read().strip())
    except IOError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
    except IndexError:
        print('please provide a file path to puzzle file, example: ./puzzle.txt')
