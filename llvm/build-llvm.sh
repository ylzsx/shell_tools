#!/bin/bash
set -x

help() {
    echo "Usage:"
    echo "  -n              start native build, default"
    echo "  -c              start cross build"
    echo "  -r              release build, default"
    echo "  -d              debug build"
    echo "  -h              help"
    echo ""
    echo "Examples:         ./build.llvm.sh -n -r"
}

ROOTDIR=$(pwd)
NPROC=$(nproc)
BUILDDIR=${BUILDDIR:-$ROOTDIR/build}
INSTALLDIR=${INSTALLDIR:-$ROOTDIR/install}

# ======================== #
# These variables can be overridden by env.
CC=${CC:-clang}
CXX=${CXX:-clang++}
CFLAGS=${CFLAGS:-}
CXXFLAGS=${CXXFLAGS:-}
LINK_PARALLEL=${LINK_PARALLEL:-$NPROC}
TARGETS=${TARGETS:-"LoongArch"}
PROJECTS=${PROJECTS:-"clang;lld"}
RUNTIMES=${RUNTIMES:-}
USE_LLD="${USE_LLD:-1}"
# ======================== #

NATIVE_BUILD=1
RELEASE_BUILD=1

parseArgs() {
    while getopts "ncrdh" opt; do
        case ${opt} in
        n)
            NATIVE_BUILD=1
            ;;
        c)
            NATIVE_BUILD=0
            ;;
        r)
            RELEASE_BUILD=1
            ;;
        d)
            RELEASE_BUILD=0
            ;;
        h)
            help
            exit
            ;;
        # option need argument, but not receive
        :)
            help
            exit
            ;;
        # undefind option
        ?)
            help
            exit
            ;;
        esac
    done
}

# common cmake args
getArgs() {
cmake_args=(
    -B $BUILDDIR
    -G Ninja
    -S llvm
    # compiler
    -DCMAKE_C_COMPILER=$CC
    -DCMAKE_CXX_COMPILER=$CXX
    -DCMAKE_C_FLAGS=$CFLAGS
    -DCMAKE_CXX_FLAGS=$CXXFLAGS
    # install
    -DCMAKE_INSTALL_PREFIX="$INSTALLDIR"
    # linker
    -DLLVM_PARALLEL_LINK_JOBS="$LINK_PARALLEL"
    # targets
    -DLLVM_TARGETS_TO_BUILD="$TARGETS"
    -DLLVM_ENABLE_PROJECTS="$PROJECTS"
    -DLLVM_ENABLE_RUNTIMES="$RUNTIMES"
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    -DLLVM_LIT_ARGS="-v --timeout=600"
    # others
    -DLLVM_INCLUDE_TOOLS=ON
    -DLLVM_BUILD_TOOLS=ON

    -DLLVM_INCLUDE_UTILS=ON
    -DLLVM_BUILD_UTILS=ON
    -DLLVM_INSTALL_UTILS=ON
    -DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF

    -DLLVM_INCLUDE_RUNTIMES=ON
    -DLLVM_BUILD_RUNTIME=ON

    -DLLVM_INCLUDE_EXAMPLES=ON
    -DLLVM_BUILD_EXAMPLES=OFF

    -DLLVM_INCLUDE_TESTS=ON
    -DLLVM_BUILD_TESTS=OFF

    -DLLVM_INCLUDE_DOCS=ON
    -DLLVM_BUILD_DOCS=OFF
    -DLLVM_ENABLE_DOXYGEN=OFF
    -DLLVM_ENABLE_SPHINX=OFF
    -DLLVM_ENABLE_OCAMLDOC=OFF
    -DLLVM_ENABLE_BINDINGS=OFF

    -DBUILD_SHARED_LIBS=OFF
    -DLLVM_BUILD_LLVM_DYLIB=ON
    -DLLVM_LINK_LLVM_DYLIB=ON

    -DLLVM_ENABLE_LIBCXX=OFF
    -DLLVM_ENABLE_ZLIB=ON
    -DLLVM_ENABLE_FFI=ON
    -DLLVM_ENABLE_RTTI=ON
)

if [[ USE_LLD -eq 1 ]]; then
  cmake_args+=("-DLLVM_USE_LINKER=lld")
fi
}

nativeRelease() {
    rm -rf $BUILDDIR $INSTALLDIR
    mkdir -p $BUILDDIR
    mkdir -p $INSTALLDIR

    getArgs

    cmake \
    -DCMAKE_BUILD_TYPE="Release" \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    "${cmake_args[@]}"

    cd $BUILDDIR
    ninja
}

nativeDebug() {
    rm -rf $BUILDDIR $INSTALLDIR
    mkdir -p $BUILDDIR
    mkdir -p $INSTALLDIR

    getArgs

    cmake \
    -DCMAKE_BUILD_TYPE="Debug" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    "${cmake_args[@]}"

    cd $BUILDDIR

# Debug
# -DLLVM_USE_SPLIT_DWARF=ON
# CMAKE_EXE_LINKER_FLAGS_DEBUG=-Wl,--gdb-index
#
#"-mrelax -fuse-ld=lld -Wl,-X -Wno-deprecated-copy -mcmodel=medium"
#
# distcc
# -DCMAKE_C_COMPILER_LAUNCHER=distcc
# -DCMAKE_CXX_COMPILER_LAUNCHER=distcc
}

parseArgs "$@"

if [[ $NATIVE_BUILD -eq 1 ]]; then
    if [[ $RELEASE_BUILD -eq 1 ]]; then
        nativeRelease
    else
        BUILDDIR+="-dbg"
        INSTALLDIR+="-dbg"
        nativeDebug
    fi
else
    echo "cross build is yet unsupoorted."
fi
