cmake_minimum_required (VERSION 3.5)

project (demo)

FIND_PACKAGE(CUDA REQUIRED)
if (NOT CUDA_FOUND)
  message(STATUS "CUDA not found. Project will not be built.")
endif(NOT CUDA_FOUND)

set (EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin) ## bin is the EXECUTABLE_OUTPUT_PATH

set (SRC_LIST ${PROJECT_SOURCE_DIR}/src/main.cu
    ${PROJECT_SOURCE_DIR}/include/Triangle_r.cu)

include_directories(${PROJECT_SOURCE_DIR}/include)

###
#cuda
include_directories(/usr/local/cuda/include)
#find_library(CUDA_cuda cuda HINTS /usr/local/cuda/lib64)
#find_library(CUDA_cudart cudart HINTS /usr/local/cuda/lib64)


ADD_DEFINITIONS(-std=c++17)  

CUDA_ADD_EXECUTABLE(main
    ${SRC_LIST}
    OPTIONS -arch=sm_60
)

TARGET_LINK_LIBRARIES( main ${CUDA_LIBRARIES})

if ( CMAKE_COMPILER_IS_GNUCC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wmaybe-uninitialized")
endif()
if ( MSVC )
    set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} /W4 -Wmaybe-uninitialized")
endif()