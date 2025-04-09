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

if(NOT DEFINED WEBKITGTK_V)
    set(WEBKITGTK_V "4.1")
endif()
if("${WEBKITGTK_V}" STREQUAL "6.0")
    set(WEBKITGTK_V webkitgtk-6.0)
    set(GTK_V 4)
elseif("${WEBKITGTK_V}" STREQUAL "4.0" OR "${WEBKITGTK_V}" STREQUAL "4.1")
    set(WEBKITGTK_V webkit2gtk-${WEBKITGTK_V})
    set(GTK_V +-3.0)
else()
    CONSOLE_WARN("Got an invalid WebkitGTK version ${WEBKITGTK_V}")
    message("Valid values are 6.0, 4.1 or 4.0")
    message("Setting to 4.1 and proceeding...")
    set(WEBKITGTK_V webkit2gtk-4.1)
    set(GTK_V +-3.0)
endif()

if(NOT TARGETED)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(GTK REQUIRED gtk${GTK_V})
    pkg_check_modules(WEBKIT REQUIRED ${WEBKITGTK_V})
    set(include_dirs "${GTK_INCLUDE_DIRS};${WEBKIT_INCLUDE_DIRS}")
    set(inlcude_libs "${GTK_LIBRARIES};${WEBKIT_LIBRARIES}")
endif()

if(TARGETED AND STATIC)
    target_link_libraries(${PROJECT_NAME} PRIVATE webview::core_static)

elseif(TARGETED AND SHARED)
    target_link_libraries(${PROJECT_NAME} PRIVATE webview::core_shared)

elseif(TARGETED)
    target_link_libraries(${PROJECT_NAME} PRIVATE webview::core)

elseif(SHARED)
    LINK_WEBVIEW_LIB(libwebviewd.so "${include_dirs}" "${inlcude_libs}" "")
    target_link_libraries(${PROJECT_NAME} PRIVATE webview_linked)

elseif(STATIC)
    LINK_WEBVIEW_LIB(libwebviewd.a "${include_dirs}" "${inlcude_libs}" "")
    target_link_libraries(${PROJECT_NAME} PRIVATE webview_linked)  

elseif(COMPILED)
    add_compile_options("${GTK_CFLAGS_OTHER};${WEBKIT_CFLAGS_OTHER}")
    target_include_directories(${PROJECT_NAME} PRIVATE ${include_dirs})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${inlcude_libs})

endif()
