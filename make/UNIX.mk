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

check_wv_build:
	@$(call pre_build, wv_build, ${WV_BUILD_DIR}, ${WV_BUILD_M})
	
build: build_compiled build_static build_shared build_targeted build_targeted_static build_targeted_shared
build_compiled:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})
	cmake --build ${BUILD_DIR_COMPILED} --config ${BUILD_TYPE}
build_static: check_wv_build
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_STATIC} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})	
	cmake --build ${BUILD_DIR_STATIC} --config ${BUILD_TYPE}
build_shared: check_wv_build
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})	
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_SHARED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${BUILD_DIR_SHARED} --config ${BUILD_TYPE}
build_targeted:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${BUILD_DIR_TARGETED} --config ${BUILD_TYPE}
build_targeted_static:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${TARGETED_STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_TARGETED_STATIC} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE \
	-D STATIC=TRUE
	@$(call build_message, ${TARGETED_STATIC_M})	
	cmake --build ${BUILD_DIR_TARGETED_STATIC} --config ${BUILD_TYPE}
build_targeted_shared:
	@$(eval USER_MESSAGE := ${PLATFORM_M} ${TARGETED_SHARED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G ${NINJA_CONFIG} -B ${BUILD_DIR_TARGETED_SHARED} -S . ${DEFS} \
	-D TARGET_FILE=${TARGET_C_FILE} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE \
	-D SHARED=TRUE
	@$(call build_message, ${TARGETED_SHARED_M})	
	cmake --build ${BUILD_DIR_TARGETED_SHARED} --config ${BUILD_TYPE}

ifeq ($(UNAME),Linux)
include make/LINUX.mk
endif

ifeq ($(UNAME),Darwin)
include make/APPLE.mk
endif
