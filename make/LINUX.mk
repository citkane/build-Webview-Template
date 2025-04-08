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
	@$(call run_message, Linux LLVM ${COMPILED_M})
	./${BUILD_DIR_COMPILED}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Linux LLVM ${STATIC_M})
	./${BUILD_DIR_STATIC}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Linux LLVM ${SHARED_M})		
	./${BUILD_DIR_SHARED}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Linux LLVM ${TARGETED_M})	
	./${BUILD_DIR_TARGETED}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Linux LLVM ${TARGETED_STATIC_M})	
	./${BUILD_DIR_TARGETED_STATIC}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, Linux LLVM ${TARGETED_SHARED_M})	
	./${BUILD_DIR_TARGETED_SHARED}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

build:
	@$(eval USER_MESSAGE := Linux LLVM ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})
	cmake --build ${BUILD_DIR_COMPILED}
build_static:
	@$(eval USER_MESSAGE := Linux LLVM ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_STATIC} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})	
	cmake --build ${BUILD_DIR_STATIC}
build_shared:
	@$(eval USER_MESSAGE := Linux LLVM ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})	
	cmake -G Ninja -B ${BUILD_DIR_SHARED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${BUILD_DIR_SHARED}
build_targeted:
	@$(eval USER_MESSAGE := Linux LLVM ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${BUILD_DIR_TARGETED}
build_targeted_static:
	@$(eval USER_MESSAGE := Linux LLVM ${TARGETED_STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_TARGETED_STATIC} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${TARGETED_STATIC_M})	
	cmake --build ${BUILD_DIR_TARGETED_STATIC}
build_targeted_shared:
	@$(eval USER_MESSAGE := Linux LLVM ${TARGETED_SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${BUILD_DIR_TARGETED_SHARED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${TARGETED_SHARED_M})	
	cmake --build ${BUILD_DIR_TARGETED_SHARED}


wv_build:
	@$(call make_wv_message, Linux LLVM)
	cmake -G "Ninja Multi-Config" -B ${WV_BUILD_DIR} -S .. ${WV_COMMON_DEFS} \
	-D CMAKE_TOOLCHAIN_FILE=cmake/toolchains/host-llvm.cmake \
	-D WEBVIEW_TOOLCHAIN_EXECUTABLE_SUFFIX=${LLVM_V} \
	-D WEBVIEW_WEBKITGTK_API=${WEBKITGTK_V}
	@$(call build_wv_message)
	cmake --build ${WV_BUILD_DIR} --config ${BUILD_TYPE}
	