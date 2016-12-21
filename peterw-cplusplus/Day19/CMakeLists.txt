
set (DAY 19)
add_executable(Day${DAY}
	"Day${DAY}.cpp"
	)


add_custom_target(Day${DAY}-run
  COMMAND Day${DAY}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day${DAY}_SOURCES}
)
set_target_properties(Day${DAY}-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
