
CFLAGS=-g -pedantic -Wall -Wextra -Werror

days=day1 day2 day3 day4

all: $(patsubst %,%-run,$(days))

tests=hashmap_test

test: $(patsubst %,%.log,$(tests))

$(patsubst %,%.log,$(tests)): %.log: %
	@echo "[ Testing: $< ]"
	@./$< && echo "$< : OK" || echo "$< : FAILED"

aoc-main.o: aoc-main.c aoc-main.h Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

hashmap.o: hashmap.c hashmap.h Makefile

%.o: %.c Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

hashmap_test: hashmap_test.o hashmap.o
	@echo "[ Linking: $@ ]"
	@gcc ${CFLAGS} -o $@ $^

day%.o: day%.c aoc-main.h Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

.PRECIOUS: day%
day%: day%.o aoc-main.o hashmap.o
	@echo "[ Linking: $@ ]"
	@gcc -g -o $@ $^

%-run: % input-%.txt test
	@echo "[ Running: $* ]"
	@echo -n "Part 1: "
	@./$* 1 < input-$*.txt
	@echo -n "Part 2: "
	@./$* 2 < input-$*.txt

clean:
	rm -f $(days) $(tests) *.o
