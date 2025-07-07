cmake_minimum_required(VERSION 3.16)
project(statediff-RECUP LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Optional: allow specifying external install paths
set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install CACHE PATH "Install path prefix")

# Assume Spack or user provides CMAKE_PREFIX_PATH with dependencies
find_package(Kokkos REQUIRED)
find_package(OpenMP REQUIRED)
find_package(OpenSSL REQUIRED)

# Add state-diff subproject
set(STATE_DIFF_DIR ${CMAKE_SOURCE_DIR}/external/state-diff)
add_subdirectory(${STATE_DIFF_DIR} EXCLUDE_FROM_ALL)

# If state-diff provides a CMake target like statediff::statediff, use that.
# Otherwise, use the target name defined inside (e.g., statediff)

# Optional: build a demo/external app that uses statediff
# add_executable(use_statediff use_statediff.cpp)
# target_link_libraries(use_statediff PRIVATE statediff)
# target_include_directories(use_statediff PRIVATE ${STATE_DIFF_DIR}/include)

# # Install the demo app
# install(TARGETS use_statediff RUNTIME DESTINATION bin)
