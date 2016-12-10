
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
