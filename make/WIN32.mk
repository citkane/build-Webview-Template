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

run:
	@$(call run_message, Windows MINGW ${COMPILED_M})
	./${BUILD_DIR_COMPILED}/bin/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MINGW ${STATIC_M})
	./${BUILD_DIR_STATIC}/bin/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MINGW ${SHARED_M})
	./${BUILD_DIR_SHARED}/bin/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MINGW ${TARGETED_M})
	./${BUILD_DIR_TARGETED}/bin/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MSVC ${COMPILED_M})
	./${MSVC_BUILD_DIR_COMPILED}/bin/${BUILD_TYPE}/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MSVC ${STATIC_M})
	./${MSVC_BUILD_DIR_STATIC}/bin/${BUILD_TYPE}/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MSVC ${SHARED_M})
	./${MSVC_BUILD_DIR_SHARED}/bin/${BUILD_TYPE}/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Windows MSVC ${TARGETED_M})
	./${MSVC_BUILD_DIR_TARGETED}/bin/${BUILD_TYPE}/${SYSTEM_PROJECT_NAME}.exe
	@$(call message, ${SUCCESS_M})

win_build:
	@$(eval USER_MESSAGE := Windows MINGW ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})
	cmake --build ${BUILD_DIR_COMPILED}
win_build_static:
	@$(eval USER_MESSAGE := Windows MINGW ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_STATIC} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})
	cmake --build ${BUILD_DIR_STATIC}
win_build_shared:
	@$(eval USER_MESSAGE := Windows MINGW ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_SHARED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${BUILD_DIR_SHARED}
win_build_targeted:
	@$(eval USER_MESSAGE := Windows MINGW ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WW_BUILD_DIR} \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${BUILD_DIR_TARGETED}
win_build_targeted_static:
	@$(eval USER_MESSAGE := Windows MINGW ${TARGETED_STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_TARGETED_STATIC} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WW_BUILD_DIR} \
	-D TARGETED=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${TARGETED_STATIC_M})	
	cmake --build ${BUILD_DIR_TARGETED_STATIC}
win_build_targeted_shared:
	@$(eval USER_MESSAGE := Windows MINGW ${TARGETED_SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_TARGETED_SHARED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${WV_BUILD_DIR} \
	-D TARGETED=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${TARGETED_SHARED_M})	
	cmake --build ${BUILD_DIR_TARGETED_SHARED}

msvc_build:
	@$(eval USER_MESSAGE := Windows MSVC ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})	
	cmake --build ${MSVC_BUILD_DIR_COMPILED}
msvc_build_static:
	@$(eval USER_MESSAGE := Windows MSVC ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_STATIC} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})	
	cmake --build ${MSVC_BUILD_DIR_STATIC}
msvc_build_shared:
	@$(eval USER_MESSAGE := Windows MSVC ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_SHARED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${MSVC_BUILD_DIR_SHARED}
msvc_build_targeted:
	@$(eval USER_MESSAGE := Windows MSVC ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${MSVC_V} -A ${MSVC_A} -B ${MSVC_BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D MSVC=TRUE \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${MSVC_BUILD_DIR_TARGETED}
msvc_build_targeted_static:
	@$(eval USER_MESSAGE := Windows MSVC ${TARGETED_STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${MSVC_BUILD_DIR_TARGETED_STATIC} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D TARGETED=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${TARGETED_STATIC_M})	
	cmake --build ${MSVC_BUILD_DIR_TARGETED_STATIC}
msvc_build_targeted_shared:
	@$(eval USER_MESSAGE := Windows MSVC ${TARGETED_SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${MSVC_BUILD_DIR_TARGETED_SHARED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D WV_BUILD_DIR=${MSVC_WV_BUILD_DIR} \
	-D TARGETED=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${TARGETED_SHARED_M})	
	cmake --build ${MSVC_BUILD_DIR_TARGETED_SHARED}

wv_win_build:
	@$(call make_wv_message, Windows MINGW)
	cmake -G "Ninja Multi-Config" -B ${WV_BUILD_DIR} -S .. ${WV_COMMON_DEFS} \
	-D WEBVIEW_USE_COMPAT_MINGW=TRUE \
	-W no-dev
	@$(call build_wv_message)
	cmake --build ${WV_BUILD_DIR} --config ${BUILD_TYPE}
wv_msvc_build:
	@$(call make_wv_message, Windows MSVC)
	cmake -G ${MSVC_V} -B ${MSVC_WV_BUILD_DIR} -S .. ${WV_COMMON_DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=cmake/toolchains/${PLATFORM}-windows-msvc.cmake \
	-W no-dev
	@$(call build_wv_message)
	cmake --build ${MSVC_WV_BUILD_DIR} --config ${BUILD_TYPE}
	