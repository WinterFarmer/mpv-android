#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

case "$prefix_name" in
	armv7l)
		abi="armeabi-v7a"
		;;
	arm64)
		abi="arm64-v8a"
		;;
	x86)
		abi="x86"
		;;
	x86_64)
		abi="x86_64"
		;;
	*)
		echo "Invalid architecture: $prefix_name" >&2
		exit 1
		;;
esac

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

cmake .. \
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
	-DANDROID_ABI="$abi" \
	-DANDROID_PLATFORM=23 \
	-DCMAKE_INSTALL_PREFIX="$prefix_dir" \
	-DCMAKE_INSTALL_LIBDIR=lib \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_TESTS=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DBUILD_STATIC_LIBS=ON

cmake --build . -j$cores --target install
