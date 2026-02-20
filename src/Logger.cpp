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

std::string Logger::levelToString(t_level level)
{
	switch (level)
	{
		case E_INFO:
			return BLUE " [INFO] ";
		case E_ERROR:
			return RED " [ERROR] ";
		case E_OK:
			return GREEN " [OK] ";
		case E_DEBUG:
			return MAGENTA " [DEBUG] ";
		case E_WARNING:
			return YELLOW " [WARNING] ";
		default:
			return "UNKNOWN";
	}
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

void	Logger::log(t_level level, const std::string message)
{
	char *buffer = this->getCurrentTime();
	std::ostringstream oss;
	oss << buffer << levelToString(level) << message << RESET "\n";
	std::cout << oss.str();
	if (logFile.is_open())
	{
		logFile << oss.str();
		logFile.flush();
	}
	delete[] buffer;
}
