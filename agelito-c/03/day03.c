// day03.c

#include <stdio.h>

#define MAX_TRIANGLES 2000

int valid_triangles(int* sides, int count)
{
    int valid_count = 0;

    int i;
    for(i = 0; i < count; i++)
    {
	int a,b,c;
	a = *(sides + (i * 3 + 0));
	b = *(sides + (i * 3 + 1));
	c = *(sides + (i * 3 + 2));

	int ab = ((a + b) <= c);
	int ac = ((a + c) <= b);
	int bc = ((b + c) <= a);

	valid_count += !(ab | ac | bc);
    }

    return valid_count;
}

void swizzle_sides(int* sides, int* result, int triangle_count)
{
    int i;
    for(i = 0; i < triangle_count; i++)
    {
	*(result + i + (triangle_count * 0)) = *(sides + (i * 3 + 0));
	*(result + i + (triangle_count * 1)) = *(sides + (i * 3 + 1));
	*(result + i + (triangle_count * 2)) = *(sides + (i * 3 + 2));
    }
}

int read_triangles(int* sides)
{
    int side_count = 0;
    int side_a, side_b, side_c;

    FILE* instructions = fopen("instructions.txt", "rb");

    int read_result;
    while((read_result = fscanf(instructions, "%d %d %d\n", &side_a, &side_b, &side_c)) == 3)
    {
	*(sides + side_count++) = side_a;
	*(sides + side_count++) = side_b;
	*(sides + side_count++) = side_c;
    }

    fclose(instructions);

    return (side_count / 3);
}

int part_1()
{
    int sides[MAX_TRIANGLES * 3];

    int triangles = read_triangles(sides);
    int valid = valid_triangles(sides, triangles);
    
    return valid;
}

int part_2()
{
    int sides[MAX_TRIANGLES * 3];
    int triangles = read_triangles(sides);

    int swizzled_sides[MAX_TRIANGLES * 3];
    swizzle_sides(sides, swizzled_sides, triangles);
    
    int valid = valid_triangles(swizzled_sides, triangles);

    return valid;
}

int main(int argc, char* argv[])
{
    printf("part 1: %d\n", part_1());
    printf("part 2: %d\n", part_2());
    
    return 0;
}
