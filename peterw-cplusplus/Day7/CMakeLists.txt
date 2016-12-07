
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day7 Day7.cpp input.txt config.h.in)

add_custom_target(Day7-run
  COMMAND Day7
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day7_SOURCES}
)
