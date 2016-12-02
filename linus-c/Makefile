

all: day1-run


day1: day1.c
	@gcc -pedantic -Wall -Wextra -o day1 day1.c

day1-run: day1 input-day1.txt
	@echo Day1:
	@./day1 1 < input-day1.txt
	@./day1 2 < input-day1.txt
	@echo 
