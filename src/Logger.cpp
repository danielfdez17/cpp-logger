#include "Logger.hpp"
#include "utils.hpp"

Logger::Logger(const Logger& other)
{
	(void)other;
}

Logger& Logger::operator=(const Logger& other)
{
	(void)other;
	return *this;
}

std::string Logger::getMsgLevel(std::string const& level)
{
	if (level == "info")
		return BLUE " [INFO] ";
	else if (level == "error")
		return RED " [ERROR] ";
	else if (level == "ok")
		return GREEN " [OK] ";
	else if (level == "debug")
		return MAGENTA " [DEBUG] ";
	else if (level == "warning")
		return YELLOW " [WARNING] ";
	else
		return "UNKNOWN";
}

char *Logger::getCurrentTime()
{
	time_t now = time(0);
	tm *timeinfo = localtime(&now);
	std::string str;
	char *buffer = new char[20];
	strftime(buffer, 20, "%Y-%m-%d %H:%M:%S", timeinfo);
	return buffer;
}

Logger::Logger()
{
	char *buffer = this->getCurrentTime();
	std::stringstream ss;
	ss << "logs/" << buffer << ".log";
	logFile.open(ss.str().c_str(), std::ios::out);
	if (!logFile.is_open())
	{
		std::cerr << ERROR "Failed to open log file: " << ss.str() << "\n" RESET;
	}
	delete[] buffer;
}

Logger::~Logger()
{
	if (logFile.is_open())
	{
		logFile.close();
	}
}

void	Logger::info(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss;
	oss << buffer << levelStr << message << RESET "\n";
	std::cout << oss.str();
	if (logFile.is_open())
	{
		logFile << oss.str();
		logFile.flush();
	}
	delete[] buffer;
}

void	Logger::error(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss;
	oss << buffer << levelStr << message << RESET "\n";
	std::cout << oss.str();
	if (logFile.is_open())
	{
		logFile << oss.str();
		logFile.flush();
	}
	delete[] buffer;
}

void	Logger::ok(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss;
	oss << buffer << levelStr << message << RESET "\n";
	std::cout << oss.str();
	if (logFile.is_open())
	{
		logFile << oss.str();
		logFile.flush();
	}
	delete[] buffer;
}

void	Logger::debug(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss;
	oss << buffer << levelStr << message << RESET "\n";
	std::cout << oss.str();
	if (logFile.is_open())
	{
		logFile << oss.str();
		logFile.flush();
	}
	delete[] buffer;
}

void	Logger::warning(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss;
	oss << buffer << levelStr << message << RESET "\n";
	std::cout << oss.str();
	if (logFile.is_open())
	{
		logFile << oss.str();
		logFile.flush();
	}
	delete[] buffer;
}
