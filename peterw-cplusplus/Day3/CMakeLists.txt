
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day3_p1 Day3_p1.cpp input.txt config.h.in)
add_executable(Day3_p2 Day3_p2.cpp input.txt config.h.in)

