
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day10 Day10.cpp input.txt config.h.in)

add_custom_target(Day10-run
  COMMAND Day10
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
