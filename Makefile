# * Colors
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
BLUE = \033[0;34m
RESET = \033[0m
OK = $(GREEN)[OK]$(RESET)

# * Program name
NAME = logger.a

# * Compilation
MYCPP = c++
MYCPPFLAGS = -Wall -Wextra -Werror -std=c++98 -g3 -fsanitize=address

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

all: obj logs $(NAME)

obj:
	@mkdir -p $(OBJ_DIR)

logs:
	@mkdir -p logs

clean:
	@$(RM) $(OBJS) $(MAIN_OBJ)
	@echo "$(OK) $(RED)Removed object files$(RESET)"

fclean: clean
	@$(RM) $(NAME) $(PROG)
	@echo "$(OK) $(RED)Removed $(NAME) and $(PROG)$(RESET)"

re: fclean all
	@echo "$(OK) $(YELLOW)Rebuilt $(NAME) and $(PROG)$(RESET)"

# ? This rule is for local testing purposes, it will compile main.cpp and run the program.
# ? It is not meant to be used for unit testing or any other kind of automated testing.
test: re $(PROG)
	@echo "$(OK) $(GREEN)Running tests...$(RESET)"
	@./$(PROG)

help:
	@echo "$(YELLOW)Usage: make [target]"
	@echo "$(BLUE)Targets:"
	@echo "  all     - Compile the library and the program"
	@echo "  obj     - Create the object files directory"
	@echo "  logs    - Create the logs directory"
	@echo "  clean   - Remove object files"
	@echo "  fclean  - Remove object files and executables"
	@echo "  re      - Rebuild everything"
	@echo "  test    - Compile and run the program"
	@echo "  help    - Show this help message $(RESET)"

.PHONY: all obj clean fclean re run debug

.DEFAULT_GOAL: all
