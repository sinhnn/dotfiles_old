/*
 * Project name   :
 * File name      : !FILE
 * Created date   : !DATE
 * Author         : Ngoc-Sinh Nguyen
 * Last modified  : !DATE
 * Desc           :
 */

#include "display_videos.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


struct info_t {
	char* args[4];
} /* optional variable list */;
#define URL_MAXSIZE 200
char* read_line(FILE *f)
{
    char *stringLine = (char *) malloc (sizeof(char) * URL_MAXSIZE);
    char ch = '1';
    char *p = stringLine;
	unsigned int i;
    for (i = 0; i < URL_MAXSIZE; i++) {
        ch = getc(f);
        if ( (ch == '\n') || (ch == EOF) ) {
			*p = NULL;
			break;
		}
        *p = ch; p ++;
    }
    return stringLine;
}

int read_config_file( char *ifile, struct info_t *info)
{
    FILE *f;
    f = fopen (ifile, "r");
    if( !f ) {
        printf("No such file %s\n", ifile);
        return -1;
    }

    info->args[0] = read_line(f);
    info->args[1] = read_line(f);
    info->args[2] = read_line(f);
    info->args[3] = read_line(f);

    printf("ARGS 1 : %s\n", info->args[0]);
    printf("ARGS 2 : %s\n", info->args[1]);
    printf("ARGS 3 : %s\n", info->args[2]);
    printf("ARGS 4 : %s\n", info->args[3]);
    fclose (f);
    return 0;
}


int main(int argc, char *argv[])
{
    struct info_t info;
    read_config_file("config.txt", &info);

	/* Pass config to your function */
	StartHere

    return 0;
}
