set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(BUILD_FEXCONFIG FALSE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-fuse-ld=lld-13")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "-fuse-ld=lld-13")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "-fuse-ld=lld-13")
set(CMAKE_C_COMPILER clang-13)
set(CMAKE_C_COMPILER_AR aarch64-linux-gnu-ar)
set(CMAKE_C_COMPILER_RANLIB aarch64-linux-gnu-ranlib)
set(CMAKE_C_COMPILER_TARGET aarch64-linux-gnu)
set(CMAKE_CXX_COMPILER clang++-13)
set(CMAKE_CXX_COMPILER_AR aarch64-linux-gnu-ar)
set(CMAKE_CXX_COMPILER_RANLIB aarch64-linux-gnu-ranlib)
set(CMAKE_CXX_COMPILER_TARGET aarch64-linux-gnu)
