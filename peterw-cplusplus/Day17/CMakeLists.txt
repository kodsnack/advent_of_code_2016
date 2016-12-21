
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR}/../Day5)
include_directories(../Day5/md5-1.3.0)

add_executable(Day17
	"Day17.cpp"
	"../Day5/md5-1.3.0/md5.c"
	"../Day5/md5-1.3.0/md5.h"
	"../Day5/md5-1.3.0/md5_loc.h"
	)


add_custom_target(Day17-run
  COMMAND Day17
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  SOURCES ${Day17_SOURCES}
)
set_target_properties(Day17-run PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
