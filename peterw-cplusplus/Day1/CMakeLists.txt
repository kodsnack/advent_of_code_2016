
add_executable(Day1 Day1.cpp)
add_executable(Day1_p2 Day1_p2.cpp)

add_custom_target(Day1-run
  COMMAND Day1
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day1_SOURCES}
)

add_custom_target(Day1_p2-run
  COMMAND Day1_p2
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day1_p2_SOURCES}
)
set_target_properties(Day1-run Day1_p2-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
