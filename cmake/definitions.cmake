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

target_compile_definitions(${PROJECT_NAME} PRIVATE USER_PROJECT_NAME="${USER_PROJECT_NAME}")
target_compile_definitions(${PROJECT_NAME} PRIVATE USER_PROJECT_MESSAGE="${USER_MESSAGE}")

if(NOT DEFINED MSVC)
    set(MSVC FALSE)
elseif(MSVC)
    target_compile_definitions(${PROJECT_NAME} PRIVATE IS_MSVC)
endif()
if(NOT DEFINED STATIC)
    set(STATIC FALSE)
elseif(STATIC)
    target_compile_definitions(${PROJECT_NAME} PRIVATE IS_STATIC)
endif()
if(NOT DEFINED SHARED)
    set(SHARED FALSE)
elseif(SHARED)
    target_compile_definitions(${PROJECT_NAME} PRIVATE IS_SHARED)
endif()
if(NOT DEFINED TARGETED)
    set(TARGETED FALSE)
elseif(TARGETED)
    target_compile_definitions(${PROJECT_NAME} PRIVATE IS_TARGETED)
endif()
if(NOT DEFINED COMPILED)
    set(COMPILED FALSE)
elseif(COMPILED)
    target_compile_definitions(${PROJECT_NAME} PRIVATE IS_COMPILED)
endif()
