// Copyright (c) 2026 Daniel Fernández
#pragma once

#include <ctime>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

class Logger {
 private:
    static Logger *instance;
    static std::ofstream logFile;

    Logger();
    Logger(const Logger &other);
    Logger &operator=(const Logger &other);
    static std::string getMsgLevel(std::string const &level);
    static char *getCurrentTime();
    static void logToFile(const std::string &message);

 public:
    ~Logger();
    static Logger *getInstance();
    static void info(const std::string & message);
    static void error(const std::string & message);
    static void ok(const std::string & message);
    static void debug(const std::string & message);
    static void warning(const std::string & message);
};
