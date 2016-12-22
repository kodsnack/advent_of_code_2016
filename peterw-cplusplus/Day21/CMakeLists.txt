
configure_file(config.h.in config.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

set (DAY 21)
add_executable(Day${DAY}
	"Day${DAY}.cpp"
	input.txt
	config.h.in
	)
add_custom_target(Day${DAY}-run
  COMMAND Day${DAY}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day${DAY}_SOURCES}
)
set_target_properties(Day${DAY}-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
