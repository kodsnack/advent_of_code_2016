
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_executable(Day4_p1 Day4_p1.cpp input.txt config.h.in)
add_executable(Day4_p2 Day4_p2.cpp input.txt config.h.in)

add_custom_target(Day4_p1-run
  COMMAND Day4_p1
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day4_p1_SOURCES}
)

add_custom_target(Day4_p2-run
  COMMAND Day4_p2
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day4_p2_SOURCES}
)
set_target_properties(Day4_p1-run Day4_p2-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
