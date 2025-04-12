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

run_mingw: run_compiled run_static run_shared run_targeted run_targeted_static run_targeted_shared
run_msvc: run_msvc_compiled run_msvc_static run_msvc_shared run_msvc_targeted run_msvc_targeted_static run_msvc_targeted_shared

run_compiled:
	@$(call pre_build, build_compiled, ${BUILD_DIR_COMPILED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_M} ${COMPILED_M})
	./${BUILD_DIR_COMPILED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_static:
	@$(call pre_build, build_static, ${BUILD_DIR_STATIC}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_M} ${STATIC_M})
	./${BUILD_DIR_STATIC}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_shared:
	@$(call pre_build, build_shared, ${BUILD_DIR_SHARED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_M} ${SHARED_M})
	./${BUILD_DIR_SHARED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_targeted:
	@$(call pre_build, build_targeted, ${BUILD_DIR_TARGETED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_M} ${TARGETED_M})
	./${BUILD_DIR_TARGETED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_targeted_static:
	@$(call pre_build, build_targeted_static, ${BUILD_DIR_TARGETED_STATIC}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_M} ${TARGETED_STATIC_M})
	./${BUILD_DIR_TARGETED_STATIC}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_targeted_shared:
	@$(call pre_build, build_targeted_shared, ${BUILD_DIR_TARGETED_SHARED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_M} ${TARGETED_SHARED_M})
	./${BUILD_DIR_TARGETED_SHARED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})

run_msvc_compiled:
	@$(call pre_build, msvc_build_compiled, ${MSVC_BUILD_DIR_COMPILED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_MSVC_M} ${COMPILED_M})
	./${MSVC_BUILD_DIR_COMPILED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_msvc_static:
	@$(call pre_build, msvc_build_static, ${MSVC_BUILD_DIR_STATIC}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_MSVC_M} ${STATIC_M})
	./${MSVC_BUILD_DIR_STATIC}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_msvc_shared:
	@$(call pre_build, msvc_build_shared, ${MSVC_BUILD_DIR_SHARED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_MSVC_M} ${SHARED_M})
	./${MSVC_BUILD_DIR_SHARED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_msvc_targeted:
	@$(call pre_build, msvc_build_targeted, ${MSVC_BUILD_DIR_TARGETED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_MSVC_M} ${TARGETED_M})
	./${MSVC_BUILD_DIR_TARGETED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_msvc_targeted_static:
	@$(call pre_build, msvc_build_targeted_static, ${MSVC_BUILD_DIR_TARGETED_STATIC}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_MSVC_M} ${TARGETED_STATIC_M})
	./${MSVC_BUILD_DIR_TARGETED_STATIC}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})
run_msvc_targeted_shared:
	@$(call pre_build, msvc_build_targeted_shared, ${MSVC_BUILD_DIR_TARGETED_SHARED}, ${RUN_BUILD_M})
	@$(call run_message, ${PLATFORM_MSVC_M} ${TARGETED_SHARED_M})
	./${MSVC_BUILD_DIR_TARGETED_SHARED}/${EXE_PATH}
	@$(call message, ${SUCCESS_M})

build: build_mingw build_msvc
build_mingw: build_compiled build_static build_shared build_targeted build_targeted_static build_targeted_shared
build_msvc: msvc_build_compiled msvc_build_static msvc_build_shared msvc_build_targeted msvc_build_targeted_static msvc_build_targeted_shared

check_wv_build:
	@$(call pre_build, wv_build, ${WV_BUILD_DIR}, ${MS_WV_BUILD_M})
check_wv_msvc_build:
	@$(call pre_build, wv_msvc_build, ${MSVC_WV_BUILD_DIR}, ${MS_WV_BUILD_M})

build_compiled: check_wv_build
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE_REMOTE} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})
	cmake --build ${BUILD_DIR_COMPILED} --config ${BUILD_TYPE}
build_static: check_wv_build
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_STATIC} -S . ${DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE_REMOTE} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})
	cmake --build ${BUILD_DIR_STATIC} --config ${BUILD_TYPE}
build_shared: check_wv_build
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_SHARED} -S . ${DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE_REMOTE} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${BUILD_DIR_SHARED} --config ${BUILD_TYPE}
build_targeted:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE_REMOTE} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WW_BUILD_DIR} \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${BUILD_DIR_TARGETED} --config ${BUILD_TYPE}
build_targeted_static:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${TARGETED_STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_TARGETED_STATIC} -S . ${DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE_REMOTE} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WW_BUILD_DIR} \
	-D TARGETED=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${TARGETED_STATIC_M})	
	cmake --build ${BUILD_DIR_TARGETED_STATIC} --config ${BUILD_TYPE}
build_targeted_shared:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${TARGETED_SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_TARGETED_SHARED} -S . ${DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE_REMOTE} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D TARGETED=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${TARGETED_SHARED_M})	
	cmake --build ${BUILD_DIR_TARGETED_SHARED} --config ${BUILD_TYPE}

msvc_build_compiled: check_wv_msvc_build
	@$(eval USER_MESSAGE := ${PLATFORM_MSVC_M} ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})	
	cmake --build ${MSVC_BUILD_DIR_COMPILED} --config ${BUILD_TYPE}
msvc_build_static: check_wv_msvc_build
	@$(eval USER_MESSAGE := ${PLATFORM_MSVC_M} ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_STATIC} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})	
	cmake --build ${MSVC_BUILD_DIR_STATIC} --config ${BUILD_TYPE}
msvc_build_shared: check_wv_msvc_build
	@$(eval USER_MESSAGE := ${PLATFORM_MSVC_M} ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_SHARED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${MSVC_BUILD_DIR_SHARED} --config ${BUILD_TYPE}
msvc_build_targeted:
	@$(eval USER_MESSAGE := ${PLATFORM_MSVC_M} ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${MSVC_BUILD_DIR_TARGETED} --config ${BUILD_TYPE}
msvc_build_targeted_static:
	@$(eval USER_MESSAGE := ${PLATFORM_MSVC_M} ${TARGETED_STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_TARGETED_STATIC} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D TARGETED=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${TARGETED_STATIC_M})	
	cmake --build ${MSVC_BUILD_DIR_TARGETED_STATIC} --config ${BUILD_TYPE}
msvc_build_targeted_shared:
	@$(eval USER_MESSAGE := ${PLATFORM_MSVC_M} ${TARGETED_SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_TARGETED_SHARED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D TARGETED=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${TARGETED_SHARED_M})	
	cmake --build ${MSVC_BUILD_DIR_TARGETED_SHARED} --config ${BUILD_TYPE}

wv_build:
	@$(call make_wv_message, ${PLATFORM_M})
	cmake -G  ${NINJA_CONFIG} -B ${WV_BUILD_DIR} -S .. ${WV_COMMON_DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=${MINGW_TOOLCHAIN_FILE} \
	-D WEBVIEW_USE_COMPAT_MINGW=TRUE \
	-W no-dev
	@$(call build_wv_message)
	cmake --build ${WV_BUILD_DIR} --config ${BUILD_TYPE}
wv_msvc_build:
	@$(call make_wv_message, ${PLATFORM_MSVC_M})
	cmake -G ${MSVC_V} -B ${MSVC_WV_BUILD_DIR} -S .. ${WV_COMMON_DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=cmake/toolchains/${PLATFORM}-windows-msvc.cmake \
	-W no-dev
	@$(call build_wv_message)
	cmake --build ${MSVC_WV_BUILD_DIR} --config ${BUILD_TYPE}
	