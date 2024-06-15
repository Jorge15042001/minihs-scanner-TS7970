PROJECT_DIR := minihs-scanner
PROJECT_SRC_DIR := $(PROJECT_DIR)/src
PROJECT_BUILD_DIR := $(PROJECT_DIR)/build_fast
PROJECT_BUILD_OUTPUT := $(PROJECT_BUILD_DIR)/src

# Find all source files
PROJECT_SRC_FILES := $(shell find $(PROJECT_SRC_DIR) -type f)

# Define build dependencies
PROJECT_BUILD_FILES := $(PROJECT_DIR)/CMakeLists.txt \
                       $(PROJECT_DIR)/CMakePresets.json \
                       $(PROJECT_DIR)/Dependencies.cmake \
                       $(PROJECT_DIR)/fast_build.sh \
                       $(PROJECT_DIR)/ProjectOptions.cmake \
                       $(shell find $(PROJECT_DIR)/cmake -type f)

# Combined list of all project files
PROJECT_FILES := $(PROJECT_SRC_FILES) $(PROJECT_BUILD_FILES)

# Docker container build rule
docker: Dockerfile
	sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes 
	sudo docker build --tag armhf-bullseye-toolchain .

# Compilation rule inside the Docker container
compilation: docker
	sudo docker run --rm --volume $(shell pwd):/work armhf-bullseye-toolchain bash -c "cd /work/$(PROJECT_DIR); bash fast_build.sh"

# Package the whole build into a zip
full_build_package: compilation
	cd $(PROJECT_BUILD_DIR); zip -r ../../fullbuild.zip .

# Package the project source build into a zip (excluding 3rd party libraries)
src_build_package: compilation
	cd $(PROJECT_BUILD_OUTPUT); zip -r ../../../srcbuild.zip .

# Package only the binaries into a zip
binary_build_package: compilation
	zip -j binbuild.zip $(PROJECT_BUILD_OUTPUT)/cameraDriver/cameraServer \
                         $(PROJECT_BUILD_OUTPUT)/controller/controller \
                         $(PROJECT_BUILD_OUTPUT)/motorDriver/motorServer

# Default target to build everything
all: full_build_package src_build_package binary_build_package

.PHONY: docker compilation full_build_package src_build_package binary_build_package all

