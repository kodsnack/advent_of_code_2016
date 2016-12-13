
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day12 Day12.cpp input.txt config.h.in)

add_custom_target(Day12-run
  COMMAND Day12
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
