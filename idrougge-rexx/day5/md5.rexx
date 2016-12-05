/* Naïve implementation of MD5 hashing function in REXX 
   Only handles messages < 447 bytes */
numeric digits 22
parse arg input
if input='' then do
	input = "The quick brown fox jumps over the lazy dog"
	input = 'message digest'
	input = 'abc5278568'
	input = 'abc5017308'
	input = 'abc' /* 900150983cd24fb0d6963f7d28e17f72 */
	input = '' /* 0cc175b9c0f1b6a831c399e269772661 */
	end
messagelength = (length(input) * 8) // (2**64)
input = c2b(input)
input = input || 1
if length(input) > 447 then say 'För långt meddelande!'
input = left(input,512-64,0)
input = input || left(d2b(messagelength), 64, 0)
say input
call setuptables
a0 = '67452301'x ; b0 = 'efcdab89'x ; c0 = '98badcfe'x ; d0 = '10325476'x
a=a0 ; b=b0 ; c=c0 ; d=d0
do i = 0 to 15
	parse var input m.i +32 input
	m.i = b2c(m.i)
	m.i = byteswap(m.i)
end
do i = 0 to 63
	if length(b) <> 4 then signal lenerr
    if length(c) <> 4 then signal lenerr
	if length(d) <> 4 then signal lenerr
	select
		when i < 16 then do
			/* F := (B and C) or ((not B) and D) */
			f = bitor( bitand(b,c), bitand(bitnot(b),d) )
			if length(f) < 4 then signal lenerr
			g = i
		end
		when i < 32 then do
			/* F := (D and B) or ((not D) and C) */
			/* g := (5×i + 1) mod 16 */
			f = bitor( bitand(d,b), bitand(bitnot(d), c) )
			if length(c) <> 4 then signal lenerr
			g = ((5 * i) + 1) // 16
		end
		when i < 48 then do
			/* F := B xor C xor D */
            /* g := (3×i + 5) mod 16 */
            f = bitxor(bitxor(b,c),d)
            if length(f) <> 4 then signal lenerr
            g = ((3 * i) + 5) // 16
        end
        when i < 64 then do
        	/* F := C xor (B or (not D)) */
            /* g := (7×i) mod 16 */
            f = bitxor(c, bitor(b,bitnot(d)))
            g = (7 * i) // 16
        end
        otherwise exit 20
    end
    say i s.i
    dtemp = d
    d = c
    c = b
    temp = 0
    temp = ( c2d(a) + c2d(f) ) // (2**32)
    temp = ( temp + c2d(k.i) ) // (2**32)
    temp = ( temp + c2d(m.g) ) // (2**32)
    /*
    temp = bitrol(right(d2c(temp),4,'0'x), s.i)
    */
    temp = d2c(temp)
    if length(temp) <> 4 then do
    	say 'Ogiltig längd!'
    	exit
    end
    temp = bitrol(temp, s.i)
    b = c2d(b)
    b = (b + c2d(temp)) // (2**32)
    b = d2c(b)
    if length(b) <> 4 then do
    	say 'b för kort!'
    	say c2b(b) '('length(b)')'
    	b = right(b,4,'0'x)
    	say c2b(b) '('length(b)')'
    end
    a = dtemp
end
a0 = d2c( (c2d(a0) + c2d(a)) // (2**32) )
b0 = d2c( (c2d(b0) + c2d(b)) // (2**32) )
c0 = d2c( (c2d(c0) + c2d(c)) // (2**32) )
d0 = d2c( (c2d(d0) + c2d(d)) // (2**32) )
digest = byteswap(a0) || byteswap(b0) || byteswap(c0) || byteswap(d0)
/*
say 'digest' c2x(digest)
say 'digest' c2b(digest)
*/
say 'digest' c2x(digest)
return digest
exit

lenerr:
say 'Längdfel på rad' sigl':'
say 'i:' i 'g:' g
say 'b:' c2b(b) length(b)
say 'c:' c2b(c) length(c)
say 'd:' c2b(d) length(d)
say 'f:' c2b(f) length(f)
exit
return

ff:
x = arg(1) ; y = arg(2) ; z = arg(3)
temp = bitor( bitand(x,y), bitand(bitnot(x),z) )
return


setuptables:
/*
sintab = 'd76aa478 e8c7b756 242070db c1bdceee f57c0faf 4787c62a a8304613 fd469501 698098d8 8b44f7af ffff5bb1 895cd7be 6b901122 fd987193 a679438e 49b40821 f61e2562 c040b340 265e5a51 e9b6c7aa d62f105d 02441453 d8a1e681 e7d3fbc8 21e1cde6 c33707d6 f4d50d87 455a14ed a9e3e905 fcefa3f8 676f02d9 8d2a4c8a fffa3942 8771f681 6d9d6122 fde5380c a4beea44 4bdecfa9 f6bb4b60 bebfbc70 289b7ec6 eaa127fa d4ef3085 04881d05 d9d4d039 e6db99e5 1fa27cf8 c4ac5665 f4292244 432aff97 ab9423a7 fc93a039 655b59c3 8f0ccc92 ffeff47d 85845dd1 6fa87e4f fe2ce6e0 a3014314 4e0811a1 f7537e82 bd3af235 2ad7d2bb eb86d391'
*/
sintab = 'd76aa478 e8c7b756 242070db c1bdceee f57c0faf 4787c62a a8304613 fd469501 698098d8 8b44f7af ffff5bb1 895cd7be 6b901122 fd987193 a679438e 49b40821 f61e2562 c040b340 265e5a51 e9b6c7aa d62f105d  2441453 d8a1e681 e7d3fbc8 21e1cde6 c33707d6 f4d50d87 455a14ed a9e3e905 fcefa3f8 676f02d9 8d2a4c8a fffa3942 8771f681 6d9d6122 fde5380c a4beea44 4bdecfa9 f6bb4b60 bebfbc70 289b7ec6 eaa127fa d4ef3085 4881d05  d9d4d039 e6db99e5 1fa27cf8 c4ac5665 f4292244 432aff97 ab9423a7 fc93a039 655b59c3 8f0ccc92 ffeff47d 85845dd1 6fa87e4f fe2ce6e0 a3014314 4e0811a1 f7537e82 bd3af235 2ad7d2bb eb86d391'
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