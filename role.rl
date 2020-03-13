#include <string.h>
#include <stdio.h>

%%{
	machine nssrole;

	action return {
		fret;
	}

	action role_found {
		printf("role found\n");
	}
	action privilege_found {
		printf("privilege found\n");
	}
	action rdelim_found {
		printf("role delimiter found\n");
	}
	action space_found {
		printf("space found\n");
	}
	action rdef_found {
		printf("role definition found\n");
	}
	action comment_found {
		printf("comment found\n");
	}
	action entry_found {
		printf("entry found\n");
	}
	action text_found {
		printf("text found\n");
	}
	action newline_found {
		printf("newline found\n");
	}
	action hash_found {
		printf("hash found\n");
	}

	action call_comment {
		fcall comment_text;
	}
	action call_role {
		fcall role_definition;
	}

	newline = '\n' > newline_found;
	hash = '#' > hash_found;
	role = (alnum -- hash)* > role_found;
	role_delimiter = ':' > rdelim_found;
	privilege = space* (alnum -- hash)+ space* > privilege_found;
	else = alnum > privilege_found;

	role_definition := space* role space* role_delimiter privilege* > rdef_found;
	comment_text := space* (extend* -- newline) newline* > text_found;
	comment := space* hash @call_comment > comment_found;

	#role_entry := role_definition;

	#main := role_entry*;
	main := (space* hash)* @call_comment | (space* alnum)* @call_role;
}%%

%% write data;

int main (int argc, char **argv) {
    char *source = NULL;
    FILE *fp = fopen("test.role", "r");
    long bufsize;
    if (fp != NULL) {
        /* Go to the end of the file. */
        if (fseek(fp, 0L, SEEK_END) == 0) {
            /* Get the size of the file. */
            bufsize = ftell(fp);
            if (bufsize == -1) { /* Error */ }

            /* Allocate our buffer to that size. */
            source = malloc(sizeof(char) * (bufsize + 1));

            /* Go back to the start of the file. */
            if (fseek(fp, 0L, SEEK_SET) != 0) { /* Error */ }

            /* Read the entire file into memory. */
            size_t newLen = fread(source, sizeof(char), bufsize, fp);
            if (newLen == 0) {
                fputs("Error reading file", stderr);
            } else {
                source[++newLen] = '\0'; /* Just to be safe. */
            }
        }
        fclose(fp);
    }


	printf(source);
	int cs, top, res = 0;
	const char *eof;

	char *p = source;
	char *pe = source + sizeof(source);
	eof = pe;
	top = 10000;
	char stack[top];
	%% write init;
	%% write exec;

	return 0;
}

