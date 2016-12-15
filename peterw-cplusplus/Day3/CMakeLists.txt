
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day3_p1 Day3_p1.cpp input.txt config.h.in)
add_executable(Day3_p2 Day3_p2.cpp input.txt config.h.in)

add_custom_target(Day3_p1-run
  COMMAND Day3_p1
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day3_p1_SOURCES}
)

add_custom_target(Day3_p2-run
  COMMAND Day3_p2
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day3_p2_SOURCES}
)
set_target_properties(Day3_p1-run Day3_p2-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
