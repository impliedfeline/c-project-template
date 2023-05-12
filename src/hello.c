#include "module/module.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  double e = exp(1);
  char *greet = greeting("World");

  printf("%s\n", greet);
  printf("Euler's number is %f.\n", e);

  free(greet);

  return EXIT_SUCCESS;
}
