#!/bin/bash
# lets print every executed statement in log
set -x
echo "Build script for custom framework with some private headers exposed"
# Fill free to use xCode warning message
# echo "error: Your error message"
# Fill free to use xCode error message
# echo "warning: Your warning message"

# Combine iOS Device and Simulator libraries for the various architectures
# into a single framework.

# Remove build directories if exist.
if [ -d "${BUILT_PRODUCTS_DIR}" ]; then
rm -rf "${BUILT_PRODUCTS_DIR}"
fi

# prepare variables

STRIPPED_OUTPUT_FOLDER="${OUTPUT_FOLDER%\"}"
STRIPPED_OUTPUT_FOLDER="${STRIPPED_OUTPUT_FOLDER#\"}"
FRAMEWORK_NAME=${FRAMEWORK_TARGET_NAME}
FRAMEWORK_FOLDER_NAME="${FRAMEWORK_NAME}.framework"
FRAMEWORK_LOCATION="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${LIB_IN_FRAMEWORK_FOLDER}"
FRAMEWORK_LIB_NAME=${FRAMEWORK_NAME}
LIB_IN_FRAMEWORK_FOLDER="${FRAMEWORK_FOLDER_NAME}/${FRAMEWORK_NAME}"

# Remove framework if exists.
if [ -d "${STRIPPED_OUTPUT_FOLDER}/${FRAMEWORK_FOLDER_NAME}" ]; then
rm -rf "${STRIPPED_OUTPUT_FOLDER}/${FRAMEWORK_FOLDER_NAME}"
fi
# Create output directory.
mkdir -p ${STRIPPED_OUTPUT_FOLDER}

# Build static library for iOS Device.
xcodebuild -target "${FRAMEWORK_TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration "${CONFIGURATION}" clean build -sdk "iphoneos" ARCHS="armv7 arm64" BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OBJROOT="${OBJROOT}" SYMROOT="${SYMROOT}" "${ACTION}" -UseModernBuildSystem=NO

# Build static library for iOS Simulator.
xcodebuild -target "${FRAMEWORK_TARGET_NAME}" ONLY_ACTIVE_ARCH=NO -configuration "${CONFIGURATION}" clean build -sdk "iphonesimulator" ARCHS="i386 x86_64" BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OBJROOT="${OBJROOT}" SYMROOT="${SYMROOT}" "${ACTION}" -UseModernBuildSystem=NO

# Create universal framework using lipo.
lipo -create "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${LIB_IN_FRAMEWORK_FOLDER}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${LIB_IN_FRAMEWORK_FOLDER}" -output "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${LIB_IN_FRAMEWORK_FOLDER}"

# Copy the framework to the library directory.
ditto "${FRAMEWORK_LOCATION}" "${STRIPPED_OUTPUT_FOLDER}"

