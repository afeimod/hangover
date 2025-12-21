#!/bin/bash
set -e

# 脚本配置
HOVERSION=${1:-0.0.0}
PROTON_VERSION=${2:-8.0}
CODENAME=${3:-jammy}
ARCH=${4:-arm64}

echo "Building Proton for Hangover ${HOVERSION}"
echo "Proton version: ${PROTON_VERSION}"
echo "Distribution: ${CODENAME}"
echo "Architecture: ${ARCH}"

# 清理旧的构建
rm -rf build/
rm -rf proton-src/

# 克隆 Proton 源代码
echo "Cloning Proton source..."
git clone --depth=1 --branch "proton_${PROTON_VERSION}" \
    https://github.com/ValveSoftware/Proton.git proton-src

# 创建构建目录
mkdir -p build
cd build

# 应用 Hangover 的 Proton 补丁（如果需要）
if [ -d "../patches" ]; then
    echo "Applying patches..."
    for patch in ../patches/*.patch; do
        echo "Applying $(basename $patch)"
        patch -p1 < "$patch"
    done
fi

# 配置
echo "Configuring Proton..."
../proton-src/configure \
    --prefix=/opt/hangover-proton \
    --enable-win64 \
    --disable-win16 \
    --disable-tests \
    --with-x \
    --with-gstreamer \
    --with-openal \
    --with-vulkan \
    --with-mingw \
    CFLAGS="-O2 -pipe -march=armv8-a" \
    CXXFLAGS="-O2 -pipe -march=armv8-a" \
    LDFLAGS="-Wl,-Bsymbolic-functions -Wl,-z,relro"

# 构建
echo "Building Proton..."
make -j$(nproc)

# 安装到临时目录
echo "Installing to temporary directory..."
make install DESTDIR=../install

echo "Build complete!"
