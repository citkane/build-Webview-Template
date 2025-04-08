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
	@$(call run_message, MacOS AppleClang ${COMPILED_M})
	./${MAC_BUILD_DIR_COMPILED}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, MacOS AppleClang ${STATIC_M})
	./${MAC_BUILD_DIR_STATIC}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, MacOS AppleClang ${SHARED_M})		
	./${MAC_BUILD_DIR_SHARED}/bin/${SYSTEM_PROJECT_NAME}
	@$(call message, ${SUCCESS_M})

	@$(call run_message, MacOS AppleClang ${TARGETED_M})	
	./${MAC_BUILD_DIR_TARGETED}/bin/${SYSTEM_PROJECT_NAME}

mac_build:
	@$(eval USER_MESSAGE := MacOS AppleClang ${COMPILED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${MAC_BUILD_DIR_COMPILED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D COMPILED=TRUE
	@$(call build_message, ${COMPILED_M})
	cmake --build ${MAC_BUILD_DIR_COMPILED}
mac_build_static:
	@$(eval USER_MESSAGE := MacOS AppleClang ${STATIC_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${MAC_BUILD_DIR_STATIC} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D STATIC=TRUE
	@$(call build_message, ${STATIC_M})	
	cmake --build ${MAC_BUILD_DIR_STATIC}
mac_build_shared:
	@$(eval USER_MESSAGE := MacOS AppleClang ${SHARED_M})
	@$(call make_message, ${USER_MESSAGE})	
	cmake -G Ninja -B ${MAC_BUILD_DIR_SHARED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D SHARED=TRUE
	@$(call build_message, ${SHARED_M})	
	cmake --build ${MAC_BUILD_DIR_SHARED}
mac_build_targeted:
	@$(eval USER_MESSAGE := MacOS AppleClang ${TARGETED_M})
	@$(call make_message, ${USER_MESSAGE})
	cmake -G Ninja -B ${MAC_BUILD_DIR_TARGETED} -S . ${DEFS} \
	-D USER_MESSAGE="${USER_MESSAGE}" \
	-D TARGETED=TRUE
	@$(call build_message, ${TARGETED_M})	
	cmake --build ${MAC_BUILD_DIR_TARGETED}

wv_mac_build:
	@$(call make_wv_message, MacOS AppleClang)
	cmake -G "Ninja Multi-Config" -B ${WV_BUILD_DIR} -S .. ${WV_COMMON_DEFS}
	@$(call build_wv_message)
	cmake --build ${WV_BUILD_DIR} --config ${BUILD_TYPE}
	