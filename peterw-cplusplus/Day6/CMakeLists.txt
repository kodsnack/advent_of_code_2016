
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day6 Day6.cpp input.txt config.h.in)

add_custom_target(Day6-run
  COMMAND Day6
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day6_SOURCES}
)
