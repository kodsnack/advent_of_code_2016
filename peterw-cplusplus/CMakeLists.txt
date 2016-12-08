cmake_minimum_required(VERSION 3.5)

set (CMAKE_CXX_STANDARD 11)

add_subdirectory(Day1)
add_subdirectory(Day2)
add_subdirectory(Day3)
add_subdirectory(Day4)
add_subdirectory(Day5)
add_subdirectory(Day6)
add_subdirectory(Day7)
add_subdirectory(Day8)

add_custom_target(run
  DEPENDS
    Day1-run Day1_p2-run
    Day2-run Day2_p2-run
    Day3_p1-run Day3_p2-run
    Day4_p1-run Day4_p2-run
    Day5-run
    Day6-run
    Day7-run
    Day8-run
)
