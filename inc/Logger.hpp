#pragma once

#include <ctime>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

typedef enum e_level
{
	E_INFO,
	E_ERROR,
	E_OK,
	E_DEBUG,
	E_WARNING
}	t_level;

class Logger
{
private:
	std::ofstream logFile;
	Logger(const Logger& other);
	Logger& operator=(const Logger& other);
	std::string levelToString(t_level level);
	char *getCurrentTime();

public:
	Logger();
	~Logger();
	void log(t_level level, const std::string message);
};