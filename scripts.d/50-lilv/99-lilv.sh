#!/bin/bash

SCRIPT_REPO="https://github.com/lv2/lilv.git"
SCRIPT_COMMIT="97876806b31fedd0ebdded6ace70270277815c68"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" lilv
    cd lilv

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dtools=disabled
        -Dtests=disabled
        -Dbindings_py=disabled
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j"$(nproc)"
    ninja install
}

ffbuild_configure() {
    echo --enable-lv2
}

ffbuild_unconfigure() {
    echo --disable-lv2
}
