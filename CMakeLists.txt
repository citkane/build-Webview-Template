#
# MIT License
#
# Copyright (c) 2025 Michael Jonker
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

include(cmake/variables.cmake)
include(cmake/functions.cmake)

cmake_minimum_required(VERSION 3.16)
project(${SYSTEM_PROJECT_NAME} LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_C_STANDARD 11)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

add_executable(${PROJECT_NAME} WIN32)
include(cmake/definitions.cmake)

if(TARGETED)
    add_subdirectory(${WV_ROOT_DIR} webview)
elseif(COMPILED)
    target_include_directories(${PROJECT_NAME} PRIVATE "${WV_ROOT_DIR}/core/include")
elseif(STATIC)
    add_library(webview_linked STATIC IMPORTED)
elseif(SHARED)
    add_library(webview_linked SHARED IMPORTED)
endif()

target_sources(${PROJECT_NAME} PRIVATE ${TARGET_FILE})

if(WIN32)
    include(cmake/WIN32.cmake)
endif()
if(LINUX)
    include(cmake/LINUX.cmake)
endif()
if(APPLE)
    include(cmake/APPLE.cmake)
endif()
