// Copyright (c) 2026 Daniel Fernández
#include <iostream>
#include "../inc/Logger.hpp"
#include "../inc/utils.hpp"

int main() {
    Logger::getInstance();
    Logger::info("This is an info message.");
    Logger::error("This is an error message.");
    Logger::ok("This is an OK message.");
    Logger::debug("This is a debug message.");
    Logger::warning("This is a warning message.");

    return 0;
}
