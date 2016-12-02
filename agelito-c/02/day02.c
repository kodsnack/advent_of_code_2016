// day02.c

#include <stdio.h>
#include <stdlib.h>

int clamp(int value, int min, int max)
{
    value = (value < min ? min : value);
    value = (value > max ? max : value);
    return value;
}

void day02_part1()
{
    int keypad_x = 1;
    int keypad_y = 1;

    char character;
    size_t read;

    int keycode = 0;

    FILE* stream = fopen("instructions.txt", "rb");
    while((read = fread(&character, 1, 1, stream)) != 0)
    {
	switch(character)
	{
	case 'U':
	    keypad_y -= 1;
	    break;
	case 'D':
	    keypad_y += 1;
	    break;
	case 'L':
	    keypad_x -= 1;
	    break;
	case 'R':
	    keypad_x += 1;
	    break;
	case '\n':
	    keycode *= 10;
	    keycode += (keypad_x + keypad_y * 3) + 1;
	    break;
	}

	keypad_x = clamp(keypad_x, 0, 2);
	keypad_y = clamp(keypad_y, 0, 2);
    }

    fclose(stream);

    printf("part 1: %d\n", keycode);
}

#define MAX_KEYCODE 10

int is_valid_move(int x, int y)
{
    int center = 2;
    return (abs(center - y) + abs(center - x)) <= 2;
}

void day02_part2()
{
    int keypad_x = 0;
    int keypad_y = 2;

    char character;
    size_t read;

    char keypad[] = {
	' ', ' ', '1', ' ', ' ',
	' ', '2', '3', '4', ' ',
	'5', '6', '7', '8', '9',
	' ', 'A', 'B', 'C', ' ',
	' ', ' ', 'D', ' ', ' '
    };

    int code_index = 0;
    char keycode[MAX_KEYCODE];

    FILE* stream = fopen("instructions.txt", "rb");
    while((read = fread(&character, 1, 1, stream)) != 0)
    {
	int move_x = 0;
	int move_y = 0;
	
	switch(character)
	{
	case 'U':
	    move_y -= 1;
	    break;
	case 'D':
	    move_y += 1;
	    break;
	case 'L':
	    move_x -= 1;
	    break;
	case 'R':
	    move_x += 1;
	    break;
	case '\n':
	    keycode[code_index++] = keypad[keypad_x + keypad_y * 5];
	    break;
	}

	if(is_valid_move(keypad_x + move_x, keypad_y + move_y))
	{
	    keypad_x += move_x;
	    keypad_y += move_y;
	}
    }

    fclose(stream);

    keycode[code_index] = 0;

    printf("part 2: %s\n", keycode);
}

int main(int argc, char* argv[])
{
    day02_part1();
    day02_part2();
    
    return 0;
}
