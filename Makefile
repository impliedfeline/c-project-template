CC := clang

CFLAGS := -g
CFLAGS += -std=c99
CFLAGS += -Wall -Wextra -Wfloat-equal -Wundef -Wshadow -Wpointer-arith \
					-Wcast-align -Wstrict-prototypes -Wstrict-overflow=5 -Wwrite-strings \
					-Wconversion -Wunreachable-code
CFLAGS += -DUNITY_SUPPORT_64 -DUNITY_OUTPUT_COLOR

SANFLAGS := -fsanitize=address

LIBS := -lm

SRC_DIR := src
BUILD_DIR := build
TEST_DIR := test
UNITY_DIR := unity
DOC_DIR := doc

# You can add an or clause to the find command to also include C++ or assembly
# files. Note that this means you have to redefine OBJS
EXEC := $(BUILD_DIR)/hello
MAIN := $(BUILD_DIR)/$(SRC_DIR)/hello.o
SRCS := $(shell find $(SRC_DIR) -name '*.c')
OBJS := $(filter-out $(MAIN),$(SRCS:%.c=$(BUILD_DIR)/%.o))

TEST_EXEC := $(BUILD_DIR)/tests.out
TEST_SRCS := $(shell find $(TEST_DIR) $(UNITY_DIR) -name '*.c')
TEST_OBJS := $(TEST_SRCS:%.c=$(BUILD_DIR)/%.o)
MEM_EXEC := $(BUILD_DIR)/memcheck.out

DEPS := $(OBJS:.o=.d)
DEPS += $(MAIN:.o=.d)
DEPS += $(TEST_OBJS:.o=.d)

# Every folder in src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIR) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP

.PHONY: all
all: docs test run

.PHONY: run
run: $(EXEC)
	@echo "Running application."
	@$(EXEC)

.PHONY: test
test: $(TEST_EXEC)
	@echo "Running tests."
	@$(TEST_EXEC)

.PHONY: memcheck
memcheck: $(MEM_EXEC)
	@echo "Running with sanitizers."
	@$(MEM_EXEC)

.PHONY: docs
docs:
	@echo "Generating documentation."
	@doxygen -q
ifdef browser
	@echo "Opening documentation in browser."
	@xdg-open $(DOC_DIR)/html/index.html
endif

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

# The final build step
$(EXEC): $(OBJS) $(MAIN)
	@$(CC) $^ -o $@ $(LDFLAGS) $(LIBS)

# The test build step
$(TEST_EXEC): $(OBJS) $(TEST_OBJS)
	@$(CC) $^ -o $@ $(LDFLAGS) $(LIBS)

# Memcheck
$(MEM_EXEC): $(OBJS) $(MAIN)
	@$(CC) $(SANFLAGS) $^ -o $@ $(LDFLAGS) $(LIBS)

# Build step for source
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)
