
configure_file(md5-1.3.0/conf.h.in conf.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(md5-1.3.0)

add_executable(Day5_p1 
	"Day5_p1.cpp"
	"md5-1.3.0/md5.c"
	"md5-1.3.0/md5.h"
	"md5-1.3.0/md5_loc.h"
	)



add_custom_target(Day5_p1-run
  COMMAND Day5_p1
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day4_p1_SOURCES}
)
