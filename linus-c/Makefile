
CFLAGS=-g -pedantic -Wall -Wextra

all: day1-run day2-run day3-run

aoc-main.o: aoc-main.c aoc-main.h Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

day%.o: day%.c aoc-main.h Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

.PRECIOUS: day%
day%: day%.o aoc-main.o
	@echo "[ Linking: $@ ]"
	@gcc -g -o $@ $^

%-run: % input-%.txt
	@echo "[ Running: $* ]"
	@echo -n "Part 1: "
	@./$* 1 < input-$*.txt
	@echo -n "Part 2: "
	@./$* 2 < input-$*.txt
