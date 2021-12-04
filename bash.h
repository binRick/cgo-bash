#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// copied from command.h
typedef struct word_desc {
  char *word;
  int flags;
} WORD_DESC;
// copied from command.h
typedef struct word_list {
  struct word_list *next;
  WORD_DESC *word;
} WORD_LIST;

// copied from general.h
typedef int sh_builtin_func_t (WORD_LIST*);

// adapted from builtins.h
typedef struct {
	char *name;
	sh_builtin_func_t *function;
	int flags;
	char * const *long_doc;
	const char *short_doc;
	char *handle;
} go_builtin;



extern go_builtin* (*external_lookup_builtin)(char*);
extern go_builtin *current_builtin;
extern int (builtin_func_wrapper)(WORD_LIST*);
extern int Main(int argc, char **argv, char **env);

static int go_builtins_sz = 0;
static go_builtin *go_builtins = 0;


