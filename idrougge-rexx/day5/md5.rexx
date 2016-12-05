/* REXX */
numeric digits 24
arg input
if input='' then do
	input = "The quick brown fox jumps over the lazy dog"
	input = 'abc'
	input = 'message digest'
end
messagelength = (length(input) * 8) // (2**64)
say c2d('H')
say 'messagelength:' messagelength
say 'len' length(input)
input = c2b(input)
say input
say 'len' length(input)
input = input || 1
say 'len' length(input)
input = left(input,512-64,0)
say 'len' length(input)
say input
/*
input = input || right(d2b(messagelength), 64, 0)
*/
input = input || left(d2b(messagelength), 64, 0)
say 'len' length(input)
say 'len' x2d(b2x(right(input,64)))
say 'len' c2d(byteswap(b2c(right(input,64))))

say input
call setuptables
a0 = '01234567'x ; b0 = '89abcdef'x ; c0 = 'fedcba98'x ; d0 = '76543210'x
a0 = '67452301'x ; b0 = 'efcdab89'x ; c0 = '98badcfe'x ; d0 = '10325476'x
a=a0 ; b=b0 ; c=c0 ; d=d0
do i = 0 to 15
	parse var input m.i +32 input
	m.i = b2c(m.i)
	m.i = byteswap(m.i)
	say i c2b(m.i) c2d(m.i)
end
do i = 0 to 63
	select
		when i < 16 then do
			/* F := (B and C) or ((not B) and D) */
			f = bitor( bitand(b,c), bitand(bitnot(b),d) )
			g = i
		end
		when i < 32 then do
			/* F := (D and B) or ((not D) and C) */
			/* g := (5×i + 1) mod 16 */
			f = bitor( bitand(d,b), bitand(bitnot(d), c) )
			g = (5 * i + 1) // 16
		end
		when i < 48 then do
			/* F := B xor C xor D */
            /* g := (3×i + 5) mod 16 */
            f = bitxor(bitxor(b,c),d)
            g = (3 * i + 5) // 16
        end
        when i < 64 then do
        	/* F := C xor (B or (not D)) */
            /* g := (7×i) mod 16 */
            f = bitxor(c, bitor(b,bitnot(d)))
            g = (7 * i) // 16
        end
        otherwise exit 20
    end
    dtemp = d
    d = c
    c = b
    /* B := B + leftrotate((A + F + K[i] + M[g]), s[i]) */
    b = c2d(b)
    /*
    temp = c2d(bitrol(c2d(a) + c2d(f) + c2d(k.i) + c2d(m.g), s.i))
    */
    say i':' 'm.'g':' c2b(m.g)
    say 'a:' c2d(a)
    temp = 0
    temp = ( c2d(a) + c2d(f) ) // 2**32
    temp = ( temp + c2d(k.i) ) // 2**32
    temp = ( temp + c2d(m.g) ) // 2**32
    if length(d2c(temp)) <> 4 then do
    	say 'ogiltig längd:' length(d2c(temp))
    	say d2b(temp)
    end
    temp = bitrol(right(d2c(temp),4,'0'x), s.i)
    say 't:' c2b(temp) c2d(temp)
    say 'b:' b
    b = (b + c2d(temp)) // 2**32
    say 'b:' d2b(b) b
    b = d2c(b)
    a = dtemp
    say 'a:' c2d(a)
    say 'd:' c2d(d)
    say 'c:' c2d(c)
end
a0 = d2c( (c2d(a0) + c2d(a)) // 2**32 )
b0 = d2c( (c2d(b0) + c2d(b)) // 2**32 )
c0 = d2c( (c2d(c0) + c2d(c)) // 2**32 )
d0 = d2c( (c2d(d0) + c2d(d)) // 2**32 )
digest = byteswap(a0) || byteswap(b0) || byteswap(c0) || byteswap(d0)
/*
say 'digest' c2x(digest)
say 'digest' c2b(digest)
*/
return digest
exit


setuptables:
sintab = 'd76aa478 e8c7b756 242070db c1bdceee f57c0faf 4787c62a a8304613 fd469501 698098d8 8b44f7af ffff5bb1 895cd7be 6b901122 fd987193 a679438e 49b40821 f61e2562 c040b340 265e5a51 e9b6c7aa d62f105d 02441453 d8a1e681 e7d3fbc8 21e1cde6 c33707d6 f4d50d87 455a14ed a9e3e905 fcefa3f8 676f02d9 8d2a4c8a fffa3942 8771f681 6d9d6122 fde5380c a4beea44 4bdecfa9 f6bb4b60 bebfbc70 289b7ec6 eaa127fa d4ef3085 04881d05 d9d4d039 e6db99e5 1fa27cf8 c4ac5665 f4292244 432aff97 ab9423a7 fc93a039 655b59c3 8f0ccc92 ffeff47d 85845dd1 6fa87e4f fe2ce6e0 a3014314 4e0811a1 f7537e82 bd3af235 2ad7d2bb eb86d391'
shifttab = '7 12 17 22 7 12 17 22 7 12 17 22 7 12 17 22 5 9 14 20 5 9 14 20 5 9 14 20 5 9 14 20 4 11 16 23 4 11 16 23 4 11 16 23 4 11 16 23 6 10 15 21 6 10 15 21 6 10 15 21 6 10 15 21'
do i = 0 to 63
	k.i = x2c(word(sintab,i+1))
	s.i = word(shifttab,i+1)
end
return

b2c:
return x2c(b2x(arg(1)))

c2b:
return x2b(c2x(arg(1)))

d2b:
return x2b(d2x(arg(1)))

bitrol: procedure
return b2c(right(c2b(arg(1)),32-arg(2),0) || left(c2b(arg(1)),arg(2),0))

bitnot: procedure
return b2c(translate(c2b(arg(1)),10,01))

byteswap: procedure
parse arg a +1 b +1 c +1 d +1
return d || c || b || a

/* MD5 test suite:
MD5 ("") = d41d8cd98f00b204e9800998ecf8427e
MD5 ("a") = 0cc175b9c0f1b6a831c399e269772661
MD5 ("abc") = 900150983cd24fb0d6963f7d28e17f72
MD5 ("message digest") = f96b697d7cb7938d525a2f31aaf161d0
MD5 ("abcdefghijklmnopqrstuvwxyz") = c3fcd3d76192e4007dfb496cca67e13b
MD5 ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789") =
d174ab98d277d9f5a5611c2c9f419d9f
MD5 ("123456789012345678901234567890123456789012345678901234567890123456
78901234567890") = 57edf4a22be3c955ac49da2e2107b67a
*/