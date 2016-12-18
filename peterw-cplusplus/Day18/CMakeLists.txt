
add_executable(Day18
	"Day18.cpp"
	)


add_custom_target(Day18-run
  COMMAND Day18
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day18_SOURCES}
)
set_target_properties(Day18-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
