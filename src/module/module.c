#include "module.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *greeting(const char *greetee) {
  const size_t size = strlen(greetee);
  char *message = malloc(size * sizeof(char) + 9);
  if (sprintf(message, "Hello, %s!", greetee) < 0) {
    fprintf(stderr, "Encoding error occurred, exiting");
    exit(EXIT_FAILURE);
  }
  return message;
}
