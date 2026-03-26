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
		return " [INFO] ";
	else if (level == "error")
		return " [ERROR] ";
	else if (level == "ok")
		return " [OK] ";
	else if (level == "debug")
		return " [DEBUG] ";
	else if (level == "warning")
		return " [WARNING] ";
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

void Logger::logToFile(const std::string& message)
{
	if (logFile.is_open())
	{
		logFile << message;
		logFile.flush();
	}
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
	std::ostringstream oss, ossFile;
	oss << buffer << BLUE << levelStr << message << RESET "\n";
	ossFile << buffer << levelStr << message << "\n";
	std::cout << oss.str();
	this->logToFile(ossFile.str());
	delete[] buffer;
}

void	Logger::error(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss, ossFile;
	oss << buffer << RED << levelStr << message << RESET "\n";
	ossFile << buffer << levelStr << message << "\n";
	std::cerr << oss.str();
	this->logToFile(ossFile.str());
	delete[] buffer;
}

void	Logger::ok(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss, ossFile;
	oss << buffer << GREEN << levelStr << message << RESET "\n";
	ossFile << buffer << levelStr << message << "\n";
	std::cout << oss.str();
	this->logToFile(ossFile.str());
	delete[] buffer;
}

void	Logger::debug(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss, ossFile;
	oss << buffer << MAGENTA << levelStr << message << RESET "\n";
	ossFile << buffer << levelStr << message << "\n";
	std::cout << oss.str();
	this->logToFile(ossFile.str());
	delete[] buffer;
}

void	Logger::warning(const std::string message)
{
	std::string levelStr = getMsgLevel(__func__);
	char *buffer = this->getCurrentTime();
	std::ostringstream oss, ossFile;
	oss << buffer << YELLOW << levelStr << message << RESET "\n";
	ossFile << buffer << levelStr << message << "\n";
	std::cout << oss.str();
	this->logToFile(ossFile.str());
	delete[] buffer;
}
