
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day8 Day8.cpp input.txt config.h.in)

add_custom_target(Day8-run
  COMMAND Day8
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day7_SOURCES}
)
