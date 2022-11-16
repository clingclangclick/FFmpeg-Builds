#!/bin/bash

SCRIPT_REPO="https://github.com/rockchip-linux/mpp.git"
SCRIPT_COMMIT="3198035973ed76fdff8c4871ddd6e20aa539dbe9"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" mpp

    local common_config=(
        -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX"
        -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN"
        -DCMAKE_BUILD_TYPE=Release
        -DENABLE_SHARED=ON
	-DENABLE_STATIC=ON
	-DCMAKE_SYSTEM_NAME=Linux
	-DCMAKE_SYSTEM_PROCESSOR=armv8-a
        -DHAVE_DRM=ON
    )

    cd mpp/build/linux/aarch64
    MPP_TOP=$(pwd)
    cmake \
	-DCMAKE_C_FLAGS="-fPIC -DARMLINUX -Dlinux" \
	-DCMAKE_CXX_FLAGS="-fPIC -DARMLINUX -Dlinux" \
        -G "Unix Makefiles" \
        "${common_config[@]}" ${MPP_TOP}/../../..

    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-rkmpp
}

ffbuild_unconfigure() {
    echo --disable-rkmpp
}
