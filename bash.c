#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "bash.h"



//export go_lookup_builtin
static inline go_builtin* go_lookup_builtin(char *name) {
  for (go_builtin *b = go_builtins; b && b->name; b++) {
    if (!strcmp(name, b->name)) {
      return b;
    }
  }
  return 0;
}

//export go_init
static inline void go_init() {
  external_lookup_builtin = &go_lookup_builtin;
}

//export go_add_builtin
static inline void go_add_builtin(go_builtin b) {
  go_builtins_sz++;
  go_builtins = realloc(go_builtins, sizeof(go_builtin) * (go_builtins_sz + 1));
  go_builtins[go_builtins_sz-1] = b;
  go_builtins[go_builtins_sz] = (go_builtin){};
}

//export go_del_builtin
static inline void go_del_builtin(char *name) {
  for (go_builtin *b = go_builtins; b && b->name; b++) {
    if (!strcmp(name, b->name)) {
      for (go_builtin *b2 = b+1; b && b->name; b2++, b++) {
        *b = *b2;
      }
      go_builtins_sz--;
      return;
    }
  }
}


