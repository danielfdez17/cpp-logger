#include "Logger.hpp"
#include "utils.hpp"
#include <iostream>

int main()
{
	Logger logger;
	logger.log(E_INFO, "This is an info message.");
	logger.log(E_ERROR, "This is an error message.");
	logger.log(E_OK, "This is an OK message.");
	logger.log(E_DEBUG, "This is a debug message.");
	logger.log(E_WARNING, "This is a warning message.");

	return 0;
}