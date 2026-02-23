#pragma once

#include <ctime>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>


class Logger
{
private:
	// typedef enum e_level
	// {
	// 	E_INFO,
	// 	E_ERROR,
	// 	E_OK,
	// 	E_DEBUG,
	// 	E_WARNING
	// }	t_level;

	std::ofstream	logFile;

				Logger(const Logger& other);
	Logger&		operator=(const Logger& other);
	std::string	getMsgLevel(std::string const& level);
	char		*getCurrentTime();
	void		logToFile(const std::string& message);

public:
				Logger();
				~Logger();
	void		info(const std::string message);
	void		error(const std::string message);
	void		ok(const std::string message);
	void		debug(const std::string message);
	void		warning(const std::string message);
};