input = 3014387

#Part 1
#This is an example of the Josephus problem
#input = 2^n + l
#winner = 2l + 1
print 'Part 1:', 2*int(bin(input)[3:],2)+1

#Part 2
#Solving exhaustively for smaller numbers generated the following pattern.
#excluding 1, for numbers in sequence A034472 (OEIS), a(n) = 3^n + 1 the first person wins
#for x > a (where a is the largest A034472 number smaller than x)
#person x-a+1 wins if x-a+1 strictly smaller than a
#if x-a+1 >= a person a+2*(x-2*a+1)+1 wins
a_list = [3**n+1 for n in range(100)]
x = input
a = max([a for a in a_list if a <= x])
if x-a+1 < a:
    print 'Part 2:', x-a+1
else:
    print 'Part 2:', a+2*(x-2*a+1)+1
