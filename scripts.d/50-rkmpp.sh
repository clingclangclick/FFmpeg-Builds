#!/bin/bash

SCRIPT_REPO="https://github.com/rockchip-linux/mpp.git"
SCRIPT_COMMIT="3198035973ed76fdff8c4871ddd6e20aa539dbe9"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" mpp

    (
        export CC="gcc"
        export CXX="g++"
        export TARGET_CC="${FFBUILD_CROSS_PREFIX}gcc"
        export TARGET_CXX="${FFBUILD_CROSS_PREFIX}g++"
        export CROSS_COMPILE=1
        export TARGET_CFLAGS="$CFLAGS"
        export TARGET_CXXFLAGS="$CFLAGS"
        unset CFLAGS
        unset CXXFLAGS

        cd mpp/build/linux/aarch64 && ./make-Makefiles.bash
        cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DHEADERS_ONLY=ON .

        make -j$(nproc)
        make install
    )
}

ffbuild_configure() {
    echo --enable-rkmpp
}

ffbuild_unconfigure() {
    echo --disable-rkmpp
}
