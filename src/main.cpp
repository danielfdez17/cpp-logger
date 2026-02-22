#include "Logger.hpp"
#include "utils.hpp"
#include <iostream>

int main()
{
	Logger logger;
	logger.info("This is an info message.");
	logger.error("This is an error message.");
	logger.ok("This is an OK message.");
	logger.debug("This is a debug message.");
	logger.warning("This is a warning message.");

	return 0;
}