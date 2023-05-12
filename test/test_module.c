#include "../src/module/module.h"
#include "../unity/unity.h"
#include <stdlib.h>

void setUp(void) {}

void tearDown(void) {}

static void test_greeting_is_hello_world(void) {
  const char hello[] = "Hello, World!";
  char *greet = greeting("World");
  TEST_ASSERT_EQUAL_STRING(hello, greet);
  free(greet);
}

int main(void) {
  UNITY_BEGIN();
  RUN_TEST(test_greeting_is_hello_world);
  return UNITY_END();
}
