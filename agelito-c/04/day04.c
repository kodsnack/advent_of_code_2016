// day04.c

#include <stdio.h>

#define VALID_CHARACTER_COUNT 26
#define INPUT_BUFFER_CAPACITY (1024 * 64)

#define MAX_NAME_LENGTH 100
#define MAX_CHECKSUM_LENGTH 5

typedef struct
{
    char* data;
    int location;
    int length;
} token_reader;

typedef struct
{
    int name_length;
    char name[MAX_NAME_LENGTH];
    char checksum[MAX_CHECKSUM_LENGTH];
    int sector_id;
} room_data;

typedef struct
{
    char character;
    int count;
} character_count;

char reader_read_character(token_reader* reader)
{
    return *(reader->data + reader->location++);
}

int is_digit(char character)
{
    return (character >= '0' && character <= '9');
}

int is_alpha(char character)
{
    return (character >= 'a' && character <= 'z');
}

int string_compare(char* string_a, char* string_b)
{
    int i = 0, matching = 1;
    while(1)
    {
	char char_a = *(string_a + i);
	char char_b = *(string_b + i);
	
	if(char_a != char_b)
	{
	    matching = 0;
	    break;
	}

	if(char_a == 0 || char_b == 0)
	{
	    break;
	}

	++i;
    }
    return matching;
}

room_data read_room_data(token_reader* reader)
{
    room_data room = (room_data){0};
    
    char character;
    while((character = reader_read_character(reader)))
    {
	if(!is_digit(character))
	{
	    *(room.name + room.name_length) = character;
	    room.name_length += 1;
	}
	else
	{
	    reader->location--;
	    break;
	}
    }

    *(room.name + room.name_length) = 0;

    sscanf((reader->data + reader->location), "%d", &room.sector_id);

    int checksum_length = 0;
    while((character = reader_read_character(reader)) != 0 && character != '\n')
    {
	if(is_alpha(character))
	{
	    *(room.checksum + checksum_length++) = character;
	}
    }
    
    return room;
}

void count_and_sort_characters(room_data* room, character_count* characters)
{
    int i,j;
    for(i = 0; i < room->name_length; i++)
    {
	char character = *(room->name + i);
	if(is_alpha(character))
	{
	    int character_index = character - 'a';
	
	    character_count* counter = (characters + character_index);
	    counter->character = character;
	    counter->count += 1;
	}
    }

    character_count counter_temp;

    for(i = 0; i < VALID_CHARACTER_COUNT; i++)
    {
	character_count* counter_a = (characters + i);
	for(j = i + 1; j < VALID_CHARACTER_COUNT; j++)
	{
	    character_count* counter_b = (characters + j);

	    int swap = 0;
	    if(counter_a->count == counter_b->count)
	    {
		swap = counter_a->character > counter_b->character;
	    }
	    else 
	    {
		swap = counter_a->count < counter_b->count;
	    }

	    if(swap)
	    {
		counter_temp = *counter_a;
		*counter_a = *counter_b;
		*counter_b = counter_temp;
	    }
	}
    }
}

int checksum_valid(char* checksum, character_count* characters)
{
    int i, valid = 1;
    for(i = 0; i < MAX_CHECKSUM_LENGTH; i++)
    {
	if(*(checksum + i) != (characters + i)->character)
	{
	    valid = 0;
	    break;
	}
    }
    return valid;
}

void decrypt_name(char* name, int length, int shift, char* output)
{
    int i;
    for(i = 0; i < length; i++)
    {
	char character = *(name + i);
	if(is_alpha(character))
	{
	    int character_index = character - 'a';
	    character_index = (character_index + shift) % VALID_CHARACTER_COUNT;
	    *(output + i) = character_index + 'a';
	}
	else
	{
	    *(output + i) = ' ';
	}
    }

    *(output + length) = 0;
}

long read_input(char* file, char* input_buffer)
{
    FILE* instructions = fopen(file, "rb");
    fseek(instructions, 0, SEEK_END);
    long file_bytes = ftell(instructions);
    fseek(instructions, 0, SEEK_SET);
    fread(input_buffer, 1, file_bytes, instructions);
    fclose(instructions);

    input_buffer[file_bytes] = 0;

    return file_bytes;
}

int part_1()
{
    char input_buffer[INPUT_BUFFER_CAPACITY];
    
    long input_size = read_input("instructions.txt", input_buffer);
    
    token_reader reader;
    reader.data = input_buffer;
    reader.location = 0;
    reader.length = input_size;

    int sector_sum = 0;
    while(reader.location < reader.length)
    {
	room_data room = read_room_data(&reader);
	
	character_count characters[VALID_CHARACTER_COUNT] = {0};
	count_and_sort_characters(&room, characters);

	if(checksum_valid(room.checksum, characters))
	{
	    sector_sum += room.sector_id;
	}
    }
    
    return sector_sum;
}

int part_2()
{
    char input_buffer[INPUT_BUFFER_CAPACITY];
    
    long input_size = read_input("instructions.txt", input_buffer);
    
    token_reader reader;
    reader.data = input_buffer;
    reader.location = 0;
    reader.length = input_size;

    int sector = 0;
    while(reader.location < reader.length)
    {
	room_data room = read_room_data(&reader);
	
	character_count characters[VALID_CHARACTER_COUNT] = {0};
	count_and_sort_characters(&room, characters);

	int valid = checksum_valid(room.checksum, characters);

	if(valid)
	{
	    char decrypted_name[MAX_NAME_LENGTH] = {0};
	    decrypt_name(room.name, room.name_length, room.sector_id, decrypted_name);

	    if(string_compare("northpole object storage ", decrypted_name))
	    {
		sector = room.sector_id;
		break;
	    }
	}
    }
    
    return sector;
}

int main(int argc, char* argv[])
{
    printf("part 1: %d\n", part_1());
    printf("part 2: %d\n", part_2());
    
    return 0;
}
