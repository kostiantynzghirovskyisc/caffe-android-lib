#!/usr/bin/env sh
set -e

if [ -z "$ANDROID_NDK" ] && [ "$#" -eq 0 ]; then
    echo 'Either $ANDROID_NDK should be set or provided as argument'
    echo "e.g., 'export ANDROID_NDK=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    ANDROID_NDK="${1:-${ANDROID_NDK}}"
fi

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
WD="$( cd "`dirname $0`/.." && pwd )"
GLOG_ROOT=${WD}/glog
BUILD_DIR=${GLOG_ROOT}/build
ANDROID_LIB_ROOT=${WD}/android_lib
GFLAGS_HOME=${ANDROID_LIB_ROOT}/gflags
N_JOBS=${N_JOBS:-4}

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${ANDROID_NDK}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags.a" \
      -DCMAKE_INSTALL_PREFIX="${ANDROID_LIB_ROOT}/glog" \
      ..

make -j${N_JOBS}
rm -rf "${ANDROID_LIB_ROOT}/glog"
make install/strip

cd "${WD}"
