# * Library name
NAME = logger.a

# * Executable name
PROG = logger.out

# * Utils
RESET = \033[0m
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[0;33m
BLUE = \033[0;34m
MAGENTA = \033[0;35m
CYAN = \033[0;36m
LOGGER = $(MAGENTA)[$(NAME)]$(RESET)

# * Timer helper
define RUN_AND_LOG
	@start_ms=$$(date +%s%3N); \
	$(1); status=$$?; \
	end_ms=$$(date +%s%3N); \
	elapsed_ms=$$((end_ms - start_ms)); \
	if [ $$status -eq 0 ]; then \
		printf "%b [%sms]\n" "$(2)" "$$elapsed_ms"; \
	fi; \
	exit $$status
endef

# * Compiler and flags
MYCXX = c++
WARNING_FLAGS = -Wall -Wextra -Werror
CPPFLAGS = -I./inc -MMD -MP -std=c++98

BUILD_TYPE ?= release

ifeq ($(BUILD_TYPE),debug)
	OPT_FLAGS = -g3 -fsanitize=address -ggdb -O0 # Optimize for debugging, not for speed
else
	OPT_FLAGS = -O2 # Optimize for speed, but not at the cost of debuggability
endif

CFLAGS = $(WARNING_FLAGS) $(OPT_FLAGS)

# * Archiver
AR = ar -rcs

# * Removal
RM = rm -rf

NOPRINT += --no-print-directory

# * Source files
LOGGER_SRCS = src/Logger.cpp
MAIN_SRCS = src/main.cpp

# * Object files
OBJ_DIR = obj
LOGGER_OBJS = $(addprefix $(OBJ_DIR)/,$(LOGGER_SRCS:.cpp=.o))
LOGGER_DEPS = $(addprefix $(OBJ_DIR)/,$(LOGGER_SRCS:.cpp=.d))
MAIN_OBJS = $(addprefix $(OBJ_DIR)/,$(MAIN_SRCS:.cpp=.o))
MAIN_DEPS = $(addprefix $(OBJ_DIR)/,$(MAIN_SRCS:.cpp=.d))
-include $(LOGGER_DEPS) $(MAIN_DEPS)

# * Logs directory
LOGS_DIR = logs

# ! Rules
# ? Links a .cpp to its .o file
$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	@$(MYCXX) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(NAME): $(LOGGER_OBJS)
	$(call RUN_AND_LOG,$(AR) $(NAME) $(LOGGER_OBJS),$(LOGGER) $(GREEN)Built $(NAME) $(RESET))

$(PROG): $(NAME) $(MAIN_OBJS)
	$(call RUN_AND_LOG,$(MYCXX) $(CFLAGS) $(MAIN_OBJS) $(NAME) -o $(PROG),$(LOGGER) $(GREEN)Built $(PROG) $(RESET))

# ? 🔨 Compiles the whole library
all: #$(NAME)
	@build_plan="$$($(MAKE) -s -n $(NAME) $(NOPRINT) 2>&1)"; status=$$?; \
	if [ $$status -ne 0 ]; then \
		printf "%s\n" "$$build_plan"; \
		exit $$status; \
	elif [ -n "$$build_plan" ]; then \
		$(MAKE) $(NAME) $(NOPRINT); \
	else \
		printf "%b\n" "$(LOGGER) $(CYAN)Everything is up to date$(RESET)"; \
	fi

# ? 📁 Creates the objects directory if it doesn't exist
obj:
	@mkdir -p $(OBJ_DIR)

# ? 📁 Creates the logs directory if it doesn't exist
logs:
	@mkdir -p $(LOGS_DIR)

# ? 🧹 Removes the object files
clean:
	$(call RUN_AND_LOG,$(RM) $(OBJ_DIR),$(LOGGER) $(RED)Object files removed $(RESET))

# ? 🗑️ Removes both object and executable files
fclean:
	$(call RUN_AND_LOG,$(MAKE) clean $(NOPRINT); $(RM) $(NAME) $(PROG),$(LOGGER) $(RED)Removed $(RESET))

# ? 🔁 Rebuilds the library
re:
	$(call RUN_AND_LOG,$(MAKE) fclean $(NOPRINT); $(MAKE) obj logs $(NOPRINT); $(MAKE) all BUILD_TYPE=$(BUILD_TYPE) $(NOPRINT),$(LOGGER) $(YELLOW)Rebuilt $(RESET))

# ? 🧪 Compiles main.cpp and runs the program
test:
	$(call RUN_AND_LOG,$(MAKE) re $(NOPRINT); $(MAKE) obj logs $(NOPRINT); $(MAKE) $(PROG) $(NOPRINT); ./$(PROG),$(LOGGER) $(GREEN)Tests ran $(RESET))

# ? ❓ Displays this help message
help:
	@awk '\
		BEGIN { blue = "\033[0;34m"; green = "\033[0;32m"; reset = "\033[0m"; yellow = "\033[0;33m"; print yellow "Usage: make [target]"; print "Targets:" } \
		/^# \?/ { desc = substr($$0, 5); next } \
		/^$$/ { desc = ""; next } \
		/^[a-zA-Z0-9][a-zA-Z0-9_.-]*:/ { \
			target = $$1; \
			sub(/:.*/, "", target); \
			if (target !~ /^\./) \
				printf "  " blue "%-12s" reset green "%s" reset "\n", target, desc; \
			desc = ""; \
		}' $(firstword $(MAKEFILE_LIST))

.PHONY: all obj logs clean fclean re test help

.DEFAULT_GOAL := all
