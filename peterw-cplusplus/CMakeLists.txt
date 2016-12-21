cmake_minimum_required(VERSION 3.5)

set (CMAKE_CXX_STANDARD 14)

add_subdirectory(Day1)
add_subdirectory(Day2)
add_subdirectory(Day3)
add_subdirectory(Day4)
add_subdirectory(Day5)
add_subdirectory(Day6)
add_subdirectory(Day7)
add_subdirectory(Day8)
add_subdirectory(Day9)
add_subdirectory(Day10)
add_subdirectory(Day11)
add_subdirectory(Day12)
add_subdirectory(Day13)
add_subdirectory(Day14)
add_subdirectory(Day15)
add_subdirectory(Day16)
add_subdirectory(Day17)
add_subdirectory(Day18)
add_subdirectory(Day19)
add_subdirectory(Day20)
add_subdirectory(Day21)

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
    Day9-run
    Day10-run
    Day11-run
    Day12-run
    Day13-run
    Day14-run
    Day15-run
    Day16-run
    Day17-run
    Day18-run
    Day19-run
    Day20-run
    Day21-run
)
