#!/bin/bash

SCRIPT_REPO="https://github.com/lv2/lv2.git"
SCRIPT_COMMIT="778c112790ae84e7deabdac84de4147baf7937a4"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" lv2
    cd lv2

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dplugins=disabled
        -Dtests=disabled
        -Donline_docs=false
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
