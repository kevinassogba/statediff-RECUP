cmake_minimum_required(VERSION 3.16)
project(statediff-RECUP LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Kokkos REQUIRED)
find_package(OpenMP REQUIRED)
find_package(OpenSSL REQUIRED)\

set(STATE_DIFF_DIR ${CMAKE_SOURCE_DIR}/external/state-diff)
add_subdirectory(${STATE_DIFF_DIR} EXCLUDE_FROM_ALL)

enable_testing()
add_subdirectory(tests/statediff)
