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

if(NOT TARGETED)
    set(include_dirs "${WV_BUILD_DIR}/_deps/microsoft_web_webview2-src/build/native/include")
    set(include_libs "advapi32;ole32;shell32;shlwapi;user32;version")
elseif((NO MSVC) AND (SHARED OR STATIC))
    find_package(Threads REQUIRED)
    set(LINK_THREADS Threads::Threads)
endif()

if(TARGETED AND SHARED)
        target_link_libraries(${PROJECT_NAME} PRIVATE "${LINK_THREADS};webview::core_shared")
elseif(TARGETED AND STATIC)
    target_link_libraries(${PROJECT_NAME} PRIVATE "${LINK_THREADS};webview::core_static")
elseif(TARGETED)
    target_link_libraries(${PROJECT_NAME} PRIVATE webview::core)
elseif(MSVC)
    if(SHARED)
        LINK_WEBVIEW_LIB(webviewd.dll "${include_dirs}" "${inlcude_libs}" webviewd.lib)
        target_link_libraries(${PROJECT_NAME} PRIVATE webview_linked)
    elseif(STATIC)
        LINK_WEBVIEW_LIB(webview_staticd.lib "${include_dirs}" "${inlcude_libs}" "")
        target_link_libraries(${PROJECT_NAME} PRIVATE webview_linked)          
    else()
        target_include_directories(${PROJECT_NAME} PRIVATE ${include_dirs})
    endif()
else()
    if(SHARED)
        LINK_WEBVIEW_LIB(libwebviewd.dll "${include_dirs}" "${inlcude_libs}" libwebviewd.dll.a)
        target_link_libraries(${PROJECT_NAME} PRIVATE webview_linked)
    elseif(STATIC)
        LINK_WEBVIEW_LIB(libwebviewd.a "${include_dirs}" "" "")
        target_link_libraries(${PROJECT_NAME} PRIVATE webview_linked)
        target_link_libraries(${PROJECT_NAME} PRIVATE ${include_libs})
    else()
        target_include_directories(${PROJECT_NAME} PRIVATE ${include_dirs})
        target_link_libraries(${PROJECT_NAME} PRIVATE ${include_libs})
    endif()
endif()
