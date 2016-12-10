
CFLAGS=-g -pedantic -Wall -Wextra -Werror

days=day1 day2 day3 day4 day5 day6 day7 day8 day9 day10

all: $(patsubst %,%-run,$(days))

tests=hashmap_test
test_logs=$(patsubst %,%.log,$(tests))

test: $(test_logs)

$(test_logs): %.log: %
	@echo "[ Testing: $< ]"
	@./$< | tee $@ && echo "$< : OK" || echo "$< : FAILED"

aoc-main.o: aoc-main.c aoc-main.h Makefile
	@echo "[ Compiling: $< ]"
	@gcc ${CFLAGS} -o $@ -c $<

hashmap.o: hashmap.c hashmap.h Makefile

vector.o: vector.c vector.h Makefile

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
day%: day%.o aoc-main.o hashmap.o vector.o
	@echo "[ Linking: $@ ]"
	@gcc -g -lcrypto -o $@ $^

.PRECIOUS: input-day%.txt
input-day%.txt: session-cookie
	@echo "[ Downloading $@ ]"
	@curl -s -f -b session=$$(cat session-cookie) 'http://adventofcode.com/2016/day/$*/input' > $@ || { rm -f session-cookie && false; }

session-cookie: 
	@echo "What is your session cookie? (will be saved to the file session-cookie)"
	@read SESSION_COOKIE && echo $$SESSION_COOKIE > session-cookie

clean-cookie:
	@rm session-cookie

.PRECIOUS: output-%
output-%: % input-%.txt ${test_logs}
	@echo "[ Running: $* ]"
	@echo -n "Part 1: " > $@
	@./$* 1 < input-$*.txt >> $@
	@echo -n "Part 2: " >> $@
	@./$* 2 < input-$*.txt >> $@

%-run: output-%
	@echo "[ Result: $* ]"
	@cat $<

clean:
	rm -f $(days) $(tests) $(test_logs) *.o input-day*.txt output-day*
