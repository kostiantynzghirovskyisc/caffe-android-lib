#!/usr/bin/env bash
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
    export NDK_ROOT="${NDK_ROOT}"
fi

WD="$( cd "`dirname $0`" && pwd )"
cd ${WD}

export ANDROID_ABI="${ANDROID_ABI:-"armeabi-v7a with NEON"}"
export USE_OPENBLAS=${USE_OPENBLAS:-0}
export N_JOBS=${N_JOBS:-4}

if [[ "${USE_OPENBLAS}" -eq 1 ]] ; then
    ./scripts/build_openblas.sh
else
    ./scripts/get_eigen.sh
fi

./scripts/build_boost.sh
./scripts/build_gflags.sh
./scripts/build_glog.sh
./scripts/build_lmdb.sh
./scripts/build_opencv.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_caffe.sh

echo "DONE!!"
