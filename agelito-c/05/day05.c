// day05.c

#include "md5.h"

#include <stdio.h>
#include <string.h>

#define INPUT_MAX_LENGTH 128
#define PASSWORD_SEARCH_CHUNK 1024

void generate_input_data(char* base, int salt_start, int count, char* result)
{
    char input_data[INPUT_MAX_LENGTH];

    int i;
    for(i = 0; i < count; i++)
    {
	sprintf(input_data, "%s%d", base, salt_start++);
	sprintf(result, "%s", input_data);
	result += INPUT_MAX_LENGTH;
    }
}
void generate_md5_hashes(char* input_data, int count, unsigned char* result)
{
    MD5_CTX md5;
    
    unsigned char md5_result[16] = {0};

    int i;
    for(i = 0; i < count; i++)
    {
	MD5_Init(&md5);
	
	MD5_Update(&md5, input_data, strlen(input_data));
	input_data += INPUT_MAX_LENGTH;
	
	MD5_Final(md5_result, &md5);

	memcpy(result, md5_result, 16);
	result += 16;
    }
}

void digest_to_hexadecimal(unsigned char* digest, char* result)
{
    int a = 0;
    int b = 0;
    int c = 0;
    int d = 0;
    
    a = (digest[0] << 24 | digest[1] << 16 | digest[2] << 8 | digest[3]);
    b = (digest[4] << 24 | digest[5] << 16 | digest[6] << 8 | digest[7]);
    c = (digest[8] << 24 | digest[9] << 16 | digest[10] << 8 | digest[11]);
    d = (digest[12] << 24 | digest[13] << 16 | digest[14] << 8 | digest[15]);

    sprintf(result, "%.8x%.8x%.8x%.8x", a, b, c, d);
}

#define DIGEST_TO_HEX(md, n) char digest##n[33] = {0}; \
    digest_to_hexadecimal(md + (n * 16), digest##n)   \

void print_cinematic_decryption(char* input, char* password, unsigned char* md5)
{
    DIGEST_TO_HEX(md5, 0); DIGEST_TO_HEX(md5, 1); DIGEST_TO_HEX(md5, 2); DIGEST_TO_HEX(md5, 3);
    DIGEST_TO_HEX(md5, 4); DIGEST_TO_HEX(md5, 5); DIGEST_TO_HEX(md5, 6); DIGEST_TO_HEX(md5, 7);

    DIGEST_TO_HEX(md5, 8); DIGEST_TO_HEX(md5, 9); DIGEST_TO_HEX(md5, 10); DIGEST_TO_HEX(md5, 11);
    DIGEST_TO_HEX(md5, 12); DIGEST_TO_HEX(md5, 13); DIGEST_TO_HEX(md5, 14); DIGEST_TO_HEX(md5, 15);
    
    printf("\n[DECRYPTING]: %s\n", input);
    printf("%s %s %s %s\n", digest0, digest1, digest2, digest3);
    printf("%s %s %s %s\n", digest4, digest5, digest6, digest7);
    printf("%s %s %s %s\n", digest8, digest9, digest10, digest11);
    printf("%s %s %s %s\n", digest12, digest13, digest14, digest15);
    printf("[PROGRESS]: %.8s\n", password);
}

void part01(char* input, char* result)
{
    int password_length = 0;
    
    char input_data[INPUT_MAX_LENGTH * PASSWORD_SEARCH_CHUNK];
    unsigned char md5_hashes[16 * PASSWORD_SEARCH_CHUNK];
    
    int input_salt = 0;

    while(password_length < 8)
    {
	generate_input_data(input, input_salt, PASSWORD_SEARCH_CHUNK, input_data);
	input_salt += PASSWORD_SEARCH_CHUNK;
	
	generate_md5_hashes(input_data, PASSWORD_SEARCH_CHUNK, md5_hashes);

	int i;
	for(i = 0; i < PASSWORD_SEARCH_CHUNK; i++)
	{
	    unsigned char byte_0 = *(md5_hashes + (i * 16));
	    unsigned char byte_1 = *(md5_hashes + (i * 16) + 1);
	    unsigned char byte_2 = *(md5_hashes + (i * 16) + 2);
	    if(byte_0 == 0 && byte_1 == 0 && byte_2 <= 0x0f)
	    {
		char md5_digest[32 + 1];
		digest_to_hexadecimal(md5_hashes + (i * 16), md5_digest);

		*(result + password_length++) = md5_digest[5];
	    }
	}

	print_cinematic_decryption(input, result, md5_hashes);
    }

    printf("\nFOUND: %s!\n\n", result);
}

void part02(char* input, char* result)
{
    int password_length = 0;
    
    char input_data[INPUT_MAX_LENGTH * PASSWORD_SEARCH_CHUNK];
    unsigned char md5_hashes[16 * PASSWORD_SEARCH_CHUNK];
    
    int input_salt = 0;

    while(password_length < 8)
    {
	generate_input_data(input, input_salt, PASSWORD_SEARCH_CHUNK, input_data);
	input_salt += PASSWORD_SEARCH_CHUNK;
	
	generate_md5_hashes(input_data, PASSWORD_SEARCH_CHUNK, md5_hashes);

	int i;
	for(i = 0; i < PASSWORD_SEARCH_CHUNK; i++)
	{
	    unsigned char byte_0 = *(md5_hashes + (i * 16));
	    unsigned char byte_1 = *(md5_hashes + (i * 16) + 1);
	    unsigned char byte_2 = *(md5_hashes + (i * 16) + 2);
	    if(byte_0 == 0 && byte_1 == 0 && byte_2 <= 0x0f)
	    {
		char md5_digest[32 + 1];
		digest_to_hexadecimal(md5_hashes + (i * 16), md5_digest);

		int location = md5_digest[5] - '0';

		if(location >= 0 && location < 8 && *(result + location) == '*')
		{
		    *(result + location) = md5_digest[6];
		    password_length += 1;
		}
	    }
	}

	print_cinematic_decryption(input, result, md5_hashes);
    }
}

int main(int argc, char* argv[])
{
    char password1[8] = {'*', '*', '*', '*', '*', '*', '*', '*'};
    char password2[8] = {'*', '*', '*', '*', '*', '*', '*', '*'};
    
    part01("wtnhxymk", password1);
    part02("wtnhxymk", password2);

    printf("part 1: %.8s\n", password1);
    printf("part 2: %.8s\n", password2);
    
    return 0;
}
