
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day9 Day9.cpp input.txt config.h.in)

add_custom_target(Day9-run
  COMMAND Day9
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS Day9
)
