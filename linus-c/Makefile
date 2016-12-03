

all: day1-run


%: %.c Makefile
	@echo "[ Compiling: $< ]"
	@gcc -g -pedantic -Wall -Wextra -o $@ $<

%-run: % input-%.txt
	@echo "[ Running: $* ]"
	@echo -n "Part 1: "
	@./$* 1 < input-$*.txt
	@echo -n "Part 2: "
	@./$* 2 < input-$*.txt
