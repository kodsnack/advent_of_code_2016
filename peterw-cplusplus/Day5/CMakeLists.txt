
configure_file(md5-1.3.0/conf.h.in conf.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(md5-1.3.0)

add_executable(Day5
	"Day5.cpp"
	"md5-1.3.0/md5.c"
	"md5-1.3.0/md5.h"
	"md5-1.3.0/md5_loc.h"
	)


add_custom_target(Day5-run
  COMMAND Day5
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day5_SOURCES}
)
set_target_properties(Day5-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
