
CFLAGS=-g -pedantic -Wall -Wextra

all: day1-run day2-run

obj/aoc-main.o: aoc-main.c Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

obj/day%.o: day%.c Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

.PRECIOUS: day%
day%: obj/day%.o obj/aoc-main.o
	@echo "[ Linking: $< ]"
	@gcc -g -o $@ $^

%-run: % input-%.txt
	@echo "[ Running: $* ]"
	@echo -n "Part 1: "
	@./$* 1 < input-$*.txt
	@echo -n "Part 2: "
	@./$* 2 < input-$*.txt
