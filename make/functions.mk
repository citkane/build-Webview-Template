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

space := $(empty) $(empty)
SHELL_TEST := $(shell echo "test")
GREEN := \033[32m
RESET := \033[0m

ifeq ($(OS),Windows_NT)
	TO_LOWER = $(shell powershell -Command "& {Write-Output '$(strip ${1})'.ToLower()}")
	ifeq (${SHELL_TEST},"test")
		DIR_EXISTS = cmd /c if exist "${1}" (exit 0) else (exit 1)
		RM_DIR = if exist "$(1)" rd /s /q "$(1)"
		MESSAGE_GREEN = echo. && powershell -Command "Write-Host '$(strip ${1})' -ForegroundColor Green"
		MESSAGE_GREEN = echo. && powershell -Command "Write-Host '$(strip ${1})' -ForegroundColor Green"
		MESSAGE = powershell -Command "Write-Host '$(strip ${1})'"
	else
		DIR_EXISTS = test -d "${1}"
		RM_DIR = rm -rf $(1)
		MESSAGE_GREEN = printf "\n${GREEN}${1}${RESET}\n"
		MESSAGE = printf "${1}\n"
	endif
else
	UNAME := $(shell uname -s)
	TO_LOWER = $(shell echo "$(strip ${1})" | tr '[:upper:]' '[:lower:]')
	DIR_EXISTS = test -d "${1}"
	RM_DIR = rm -rf $(1)
	MESSAGE_GREEN = printf "\n${GREEN}${1}${RESET}\n"
	MESSAGE = printf "${1}\n"
endif

define pre_build
	$(call DIR_EXISTS,$(strip ${2})) || $(call message, ${3})
	$(call DIR_EXISTS,$(strip ${2})) || $(MAKE) $(strip ${1})
endef

define to_lower_snake
$(subst $(space),_,$(call TO_LOWER,${1}))
endef

define rm_dir
    $(eval DIR := $(strip ${1}))
    $(call RM_DIR,${DIR})
endef

define message
	$(call MESSAGE,$(strip ${1}))
endef

define make_message
	$(call MESSAGE_GREEN,Making \"${USER_PROJECT_NAME}\" on $(strip ${1}))
endef

define run_message
	$(call MESSAGE_GREEN,Running \"${USER_PROJECT_NAME}\" on $(strip ${1}))
endef

define build_message
	$(call MESSAGE_GREEN,Building $(strip ${1}))
endef

define build_wv_message
	$(call MESSAGE_GREEN,Building \"Webview\")
endef

define make_wv_message
	$(call MESSAGE_GREEN,Making \"Webview\" on $(strip ${1}))
endef
