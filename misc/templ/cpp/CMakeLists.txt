cmake_minimum_required(VERSION 3.1...3.24)

project(
    PNAME
    VERSION 1.0.0
    LANGUAGES CXX
)

add_executable(PNAME src/main.cpp)

install(TARGETS PNAME RUNTIME DESTINATION bin)
