
add_executable(Day16
	"Day16.cpp"
	)


add_custom_target(Day16-run
  COMMAND Day16
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day16_SOURCES}
)
set_target_properties(Day16-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
