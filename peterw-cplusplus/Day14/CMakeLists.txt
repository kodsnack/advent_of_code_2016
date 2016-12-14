
configure_file(../Day5/md5-1.3.0/conf.h.in conf.h)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(../Day5/md5-1.3.0)

add_executable(Day14
	"Day14.cpp"
	"../Day5/md5-1.3.0/md5.c"
	"../Day5/md5-1.3.0/md5.h"
	"../Day5/md5-1.3.0/md5_loc.h"
	)


add_custom_target(Day14-run
  COMMAND Day14
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day14_SOURCES}
)
