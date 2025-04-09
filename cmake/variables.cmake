if(NOT DEFINED SYSTEM_PROJECT_NAME)
    message(FATAL_ERROR "SYSTEM_PROJECT_NAME must be defined. Pass -DSYSTEM_PROJECT_NAME=executable_name to the compiler.")
endif()

if(NOT DEFINED TARGET_FILE)
    message(FATAL_ERROR "TARGET_FILE must be defined. Pass -DTARGET_FILE=target_file.cc to the compiler.")
endif()

if(NOT DEFINED WV_ROOT_DIR)
    message(FATAL_ERROR "WV_ROOT_DIR must be defined. Pass -DWV_ROOT_DIR=path/to/webview/dir to the compiler.")
endif()

if(NOT DEFINED WV_BUILD_DIR)
    message(FATAL_ERROR "WV_BUILD_DIR must be defined. Pass -DWV_BUILD_DIR=build-dir-name to the compiler.")
endif()

if(NOT DEFINED CMAKE_BUILD_TYPE)
    message(FATAL_ERROR "CMAKE_BUILD_TYPE must be defined. Pass -DCMAKE_BUILD_TYPE=Debug (One of `Debug`, `Release` or `Profile`) to the compiler.")
else()
    set(LIB_DIR ${WV_BUILD_DIR}/core/${CMAKE_BUILD_TYPE})
endif()

if(NOT DEFINED USER_MESSAGE)
    set(USER_MESSAGE "No message")
endif()
