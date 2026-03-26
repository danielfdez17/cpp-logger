# * Colors
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RESET = \033[0m
OK = $(GREEN)[$(NAME)]$(RESET)

NOPRINT := --no-print-directory

# * Program name
NAME = logger.a

# * Compilation
MYCPP = c++
WARNING_FLAGS = -Wall -Wextra -Werror -std=c++98

BUILD_TYPE ?= release

ifeq ($(BUILD_TYPE),debug)
	OPT_FLAGS = -g3 -fsanitize=address -ggdb -O0
else
	OPT_FLAGS = -O2
endif

MYCPPFLAGS = $(WARNING_FLAGS) $(OPT_FLAGS)

# * Archiver
AR = ar -rcs

# * Removal
RM = rm -rf

# * Includes
INCLUDES = -I ./inc/

# * Objects dir
OBJ_DIR = ./obj/

# * Sources files
LOGGER_DIR = ./src/
LOGGER_SRCS = Logger.cpp
MAIN_SRC = main.cpp

SRCS = $(LOGGER_SRCS)

# * Object files
OBJS = $(addprefix $(OBJ_DIR), $(SRCS:.cpp=.o))
MAIN_OBJ = $(OBJ_DIR)main.o

# * Executable program
PROG = logger.out

# * Logs directory
LOGS_DIR = ./logs/

# ! RULES
$(OBJ_DIR)%.o: $(LOGGER_DIR)%.cpp
	@mkdir -p $(OBJ_DIR)
	@$(MYCPP) $(MYCPPFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)main.o: $(LOGGER_DIR)$(MAIN_SRC)
	@mkdir -p $(OBJ_DIR)
	@$(MYCPP) $(MYCPPFLAGS) $(INCLUDES) -c $< -o $@

$(NAME): $(OBJS)
	@$(AR) $(NAME) $(OBJS)
	@echo "$(OK) $(GREEN)$(NAME)$(RESET)"

$(PROG): $(OBJS) $(MAIN_OBJ)
	@$(MYCPP) $(MYCPPFLAGS) $(MAIN_OBJ) $(NAME) -o $@
	@echo "$(OK) $(GREEN)$(PROG)$(RESET)"

# ? 🔨 Compiles the whole library
all: obj logs $(NAME)

# ? 📁 Creates the objects directory if it doesn't exist
obj:
	@mkdir -p $(OBJ_DIR)

# ? 📁 Creates the logs directory if it doesn't exist
logs:
	@mkdir -p $(LOGS_DIR)

# ? 🧹 Removes the object files
clean:
	@$(RM) $(OBJS) $(MAIN_OBJ)
	@echo "$(OK) $(RED)Removed object files$(RESET)"

# ? 🗑️ Removes both object and executable files
fclean: #clean
	@$(MAKE) $(NOPRINT) clean
	@$(RM) $(NAME) $(PROG)
	@echo "$(OK) $(RED)Removed $(NAME) and $(PROG)$(RESET)"

# ? 🔁 Rebuilds the program
re: #fclean all
	@$(MAKE) $(NOPRINT) fclean
	@$(MAKE) $(NOPRINT) all
	@echo "$(OK) $(YELLOW)Rebuilt $(NAME) and $(PROG)$(RESET)"

# ? 🧪 This rule is for local testing purposes, it will compile main.cpp and run the program.
test: #re $(PROG)
	@$(MAKE) $(NOPRINT) re
	@$(MAKE) $(NOPRINT) $(PROG)
	@echo "$(OK) $(GREEN)Running tests...$(RESET)"
	@./$(PROG)

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

.PHONY: all obj clean fclean re run debug

.DEFAULT_GOAL: all
