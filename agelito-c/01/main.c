// main.c

#include <stdio.h>
#include <stdlib.h>

const char* input_instructions = "R1, L3, R5, R5, R5, L4, R5, R1, R2, L1, L1, R5, R1, L3, L5, L2, R4, L1, R4, R5, L3, R5, L1, R3, L5, R1, L2, R1, L5, L1, R1, R4, R1, L1, L3, R3, R5, L3, R4, L4, R5, L5, L1, L2, R4, R3, R3, L185, R3, R4, L5, L4, R48, R1, R2, L1, R1, L4, L4, R77, R5, L2, R192, R2, R5, L4, L5, L3, R2, L4, R1, L5, R5, R4, R1, R2, L3, R4, R4, L2, L4, L3, R5, R4, L2, L1, L3, R1, R5, R5, R2, L5, L2, L3, L4, R2, R1, L4, L1, R1, R5, R3, R3, R4, L1, L4, R1, L2, R3, L3, L2, L1, L2, L2, L1, L2, R3, R1, L4, R1, L1, L4, R1, L2, L5, R3, L5, L2, L2, L3, R1, L4, R1, R1, R2, L1, L4, L4, R2, R2, R2, R2, R5, R1, L1, L4, L5, R2, R4, L3, L5, R2, R3, L4, L1, R2, R3, R5, L2, L3, R3, R1, R3";

#define DIRECTION_NORTH 0
#define DIRECTION_EAST 1
#define DIRECTION_SOUTH 2
#define DIRECTION_WEST 3

#define MAX_NUMBER_LENGTH 32
#define MAX_LOCATION_COORDINATES 1024
#define MAX_LOCATION_DUPLICATES 1024

typedef struct
{
    int x, y;
} location;

typedef struct
{
    location coordinates;
    int direction;
} location_direction;

typedef struct
{
    int coordinate_count;
    location coordinates[MAX_LOCATION_COORDINATES];

    int duplicate_count;
    int duplicates[MAX_LOCATION_DUPLICATES];
} location_tracker;

void location_tracker_push(location_tracker* locations, int x, int y)
{
    int i;
    for(i = 0; i < locations->coordinate_count; i++)
    {
	location* coordinates = (locations->coordinates + i);
	if(coordinates->x == x && coordinates->y == y)
	{
	    if(locations->duplicate_count == MAX_LOCATION_DUPLICATES)
	    {
		printf("too many duplicates tracked... exiting");
		exit(0);
	    }

	    *(locations->duplicates + locations->duplicate_count++) = i;
	    return;
	}
    }
    
    if(locations->coordinate_count == MAX_LOCATION_COORDINATES)
    {
	printf("too many locations tracked... exiting");
	exit(0);
    }
    
    *(locations->coordinates + locations->coordinate_count++) = (location){x, y};
}

void turn_left(location_direction* location)
{
    location->direction -= 1;
    if(location->direction < DIRECTION_NORTH)
    {
	location->direction = DIRECTION_WEST;
    }
}

void turn_right(location_direction* location)
{
    location->direction += 1;
    if(location->direction > DIRECTION_WEST)
    {
	location->direction = DIRECTION_NORTH;
    }
}

void walk(location_direction* location, int distance)
{
    switch(location->direction)
    {
    case DIRECTION_NORTH:
	location->coordinates.y += distance;
	break;
    case DIRECTION_EAST:
	location->coordinates.x += distance;
	break;
    case DIRECTION_SOUTH:
	location->coordinates.y -= distance;
	break;
    case DIRECTION_WEST:
	location->coordinates.x -= distance;
	break;
    default:
	printf("invalid direction %d... exiting\n", location->direction);
	exit(0);
	break;
    }
}

void track_walk_locations(location_tracker* locations, location from, location to)
{
    int sign_x = (to.x - from.x) > 0 ? 1 : -1;
    int sign_y = (to.y - from.y) > 0 ? 1 : -1;

    location track = from;

    while(track.x != to.x)
    {
	location_tracker_push(locations, track.x, track.y);
	track.x += sign_x;
    }

    while(track.y != to.y)
    {
	location_tracker_push(locations, track.x, track.y);
	track.y += sign_y;
    }
}

void walk_and_track(location_tracker* locations, location_direction* current_location, int distance)
{
    location previous = current_location->coordinates;
    walk(current_location, distance);
    track_walk_locations(locations, previous, current_location->coordinates);
}


int main(int argc, char* argv[])
{
    location_tracker locations = (location_tracker){0};
    location_direction current_location = (location_direction){0};

    int number_length = 0;

    // NOTE: One additional space for null terminator.
    char number_buffer[MAX_NUMBER_LENGTH+1];

    const char* read_location = input_instructions;
    
    char c;
    while((c = *read_location++) != 0)
    {
	if(c == 'R' || c == 'r')
	{
	    turn_right(&current_location);
	}
	else if(c == 'L' || c == 'l')
	{
	    turn_left(&current_location);
	}
	else if(c >= '0' && c <= '9')
	{
	    if(number_length >= MAX_NUMBER_LENGTH)
	    {
		printf("number %s about to exceed maximum length %d... exiting\n", number_buffer, MAX_NUMBER_LENGTH);
		exit(0);
	    }
	    
	    *(number_buffer + number_length++) = c;
	}
	else if(c == ',' || c == ' ')
	{
	    *(number_buffer + number_length) = 0;
	    number_length = 0;
	    
	    int distance = atoi(number_buffer);
	    walk_and_track(&locations, &current_location, distance);
	}
    }

    // NOTE: Walk any remaining distance.
    *(number_buffer + number_length) = 0;
    int distance = atoi(number_buffer);

    walk_and_track(&locations, &current_location, distance);

    location destination = current_location.coordinates;

    int grid_distance_1 = abs(destination.x) + abs(destination.y);
    
    if(locations.duplicate_count > 0)
    {
	int duplicate = locations.duplicates[0];
	destination = locations.coordinates[duplicate];
    }

    int grid_distance_2 = abs(destination.x) + abs(destination.y);
    printf("Part 1: %d\n", grid_distance_1);
    printf("Part 2: %d\n", grid_distance_2);
    
    return 0;
};
