cmake_minimum_required( VERSION 3.19 )

set( library_name mp4decrypt )

project( ${library_name} CXX )

set( CMAKE_INCLUDE_CURRENT_DIR ON )
set( CMAKE_CXX_STANDARD 17 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )
set( CMAKE_CXX_EXTENSIONS OFF )
set( CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS True )

include_directories(include)

file( GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/*.cpp ${PROJECT_SOURCE_DIR}/src/*.h ${PROJECT_SOURCE_DIR}/src/*.hpp )

set_property( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT ${library_name} )

add_library( ${library_name} SHARED ${SRC_FILES} )

target_include_directories( ${library_name} PUBLIC ${PROJECT_SOURCE_DIR}/include )
