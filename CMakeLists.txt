cmake_minimum_required(VERSION 3.10)
project(MacOSBenchmark)

file(GLOB SOURCE_FILES "src/*.cpp")
list(APPEND SOURCE_FILES "main.cpp")

add_executable(BenchmarkExec ${SOURCE_FILES})

set(CMAKE_OSX_ARCHITECTURES arm64)
set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0")

