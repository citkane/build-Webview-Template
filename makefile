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

######################################################################################
# This template provides for building a Webview application locally on each OS:
# Windows, Linux or MacOS.
#
# It does not provide for cross-compilation usage.
#
######################################################################################
# User config:

# The name of your project. The executable file name will be this name to lower_snake_case.
USER_PROJECT_NAME := Webview Build Template
# The project target C++ compilation file
TARGET_FILE := main.cc
# The project target C compilation file
TARGET_C_FILE := main.c
# One of `Debug`, `Release` or `Profile`
BUILD_TYPE := Debug
# Relative path to the root of your local Weview code repository
WEBVIEW_REL_ROOT := ..
# The full MSVC version if on Windows
MSVC_V := "Visual Studio 17 2022"
# The MSVC architecture if on Windows
MSVC_A := x64
# The Webkit GTK version if on Linux, one of 4.0, 4.1 or 6.0
WEBKITGTK_V := 6.0
# The LLVM version for Linux, one of "", -17, -18, etc.
LLVM_V := -19
# The CPU platform, one of x86_64 or i686
PLATFORM := x86_64

######################################################################################
# Do not change values below here.
######################################################################################

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include make/functions.mk
include make/variables.mk

.PHONY: clean run \
wv_build build build_static build_shared build_targeted \
wv_msvc_build mscv_build msvc_build_static msvc_build_shared msvc_build_targeted

ifeq ($(OS),Windows_NT)
all: wv_build wv_msvc_build \
build build_static build_shared build_targeted \
msvc_build msvc_build_static msvc_build_shared msvc_build_targeted

else
all: wv_build \
build build_static build_shared build_targeted build_targeted_static build_targeted_shared

endif

clean:
	$(foreach dir, ${BUILD_DIRS}, $(call rm_dir, ${dir}))

ifeq ($(OS),Windows_NT)
include make/WIN32.mk

else ifeq ($(UNAME),Linux)
include make/LINUX.mk

else ifeq ($(UNAME),Darwin)
include make/APPLE.mk

endif

	
