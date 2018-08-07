#include <stdio.h>

char *version = "1.1";

void shared_code_A() {
  printf("This is my version (libraryA): %s\n", version);
}
