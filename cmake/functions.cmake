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

if(WIN32)
    cmake_policy(SET CMP0065 NEW)
endif()

string(ASCII 27 ESCAPE)
set(YELLOW  "${ESCAPE}[33m")
set(GREEN  "${ESCAPE}[32m")
set(RESET  "${ESCAPE}[0m")

function(CONSOLE_INFO user_message)
    message("${GREEN}${user_message}${RESET}")
endfunction()

function(CONSOLE_WARN user_message)
    message("${YELLOW}${user_message}${RESET}")
endfunction()

function(LINK_WEBVIEW_LIB lib_file include_dirs include_libs imp_file)
    target_link_libraries(webview_linked INTERFACE "${include_libs}")
    set_target_properties(webview_linked PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${WV_ROOT_DIR}/core/include;${include_dirs}"
        IMPORTED_LOCATION ${LIB_DIR}/${lib_file}
        IMPORTED_IMPLIB ${LIB_DIR}/${imp_file}
    )
    if(WIN32 AND SHARED)
        add_custom_command(
            TARGET ${PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${LIB_DIR}/${lib_file}"
            "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
            COMMENT "Copying ${lib_file} to the binary directory"
        )
    endif()
endfunction()
