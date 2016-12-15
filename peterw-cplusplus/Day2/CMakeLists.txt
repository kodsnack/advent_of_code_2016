
add_executable(Day2 Day2.cpp)
add_executable(Day2_p2 Day2_p2.cpp)

add_custom_target(Day2-run
  COMMAND Day2
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day2_SOURCES}
)

add_custom_target(Day2_p2-run
  COMMAND Day2_p2
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day2_p2_SOURCES}
)
set_target_properties(Day2-run Day2_p2 PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
