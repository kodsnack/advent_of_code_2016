from collections import namedtuple


def gcd(a, b):
    while b != 0:
        t = b
        b = a % b
        a = t
    return a


def lcd(a, b):
    return a * b / gcd(a, b)


def extended_gcd(a, b):
    s = 0
    t = 1
    r = b
    old_s = 1
    old_t = 0
    old_r = a
    while r != 0:
        q = old_r // r

        tmp1 = r
        r = old_r - q * r
        old_r = tmp1

        tmp2 = s
        s = old_s - q * s
        old_s = tmp2

        tmp3 = t
        t = old_t - q * t
        old_t = tmp3

    assert(old_s*a + old_t*b == old_r)
    return (old_s, old_t, old_r)


def chinese_remainder_theorem(a1, n1, a2, n2):
    common = gcd(n1, n2)

    assert (a1 % common) == (a2 % common)

    if common == min(n1, n2):
        return (max(a1, a2), max(n1, n2))

    n = n1 * n2 // common

    n1_aux = n1 // common

    m1 = n // (common * n1_aux)
    (_, b1, _) = extended_gcd(n1_aux, m1)
    e1 = b1 % n

    n2_aux = n2 // common

    m2 = n // (common * n2_aux)
    (_, b2, _) = extended_gcd(n2_aux, m2)
    e2 = b2 % n

    a1_aux = a1 % n1
    a2_aux = a2 % n2
    
    return ((a1_aux * e1 * m1 + a2_aux * e2 * m2) % n, n)

