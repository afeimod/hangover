#!/bin/bash
set -e

echo "检查 wine64 工具依赖是否构建完成..."
if [ ! -f /opt/wine64/amd64/nls/locale.nls ]; then
    echo "错误: locale.nls 文件未找到，重新构建 nls..."
    cd /opt/wine64/amd64 && make -C nls clean && make -C nls
fi

echo "检查 wine64 工具..."
ls -la /opt/wine64/amd64/tools/ 2>/dev/null || echo "tools 目录不存在"
ls -la /opt/wine64/amd64/nls/ 2>/dev/null || echo "nls 目录不存在"

echo "设置环境变量..."
export WINEBUILD="/opt/wine64/amd64/tools/winebuild/winebuild"
export WRC="/opt/wine64/amd64/tools/wrc/wrc"
export WIDL="/opt/wine64/amd64/tools/widl/widl"
export PATH="/opt/wine64/amd64/tools:$PATH"

echo "检查工具是否存在..."
which winebuild || echo "winebuild 未找到"
which wrc || echo "wrc 未找到"
which widl || echo "widl 未找到"

echo "开始构建 Debian 包..."
cd /opt/wine

# 清理之前的构建
echo "清理之前的构建..."
debian/rules clean 2>/dev/null || true

# 检查 changelog 格式
echo "检查 changelog 格式..."
if ! head -1 debian/changelog | grep -q "^hangover-wine ([0-9]"; then
    echo "错误: changelog 版本号不以数字开头"
    echo "当前第一行:"
    head -1 debian/changelog
    exit 1
fi

echo "构建架构: arm64"
echo "使用工具链:"
echo "  WINEBUILD: $WINEBUILD"
echo "  WRC: $WRC"
echo "  WIDL: $WIDL"

# 创建构建日志目录
mkdir -p /tmp/build-logs

# 尝试不同的构建方法
echo "方法1: 使用 dh_auto_configure 配置..."
dh_auto_configure --buildsystem=autoconf -- -C \
    --host=aarch64-linux-gnu \
    --with-wine64=/opt/wine64/amd64 \
    --with-wine-tools=/opt/wine64/amd64/tools 2>&1 | tee /tmp/build-logs/configure.log

echo "方法2: 手动配置..."
cd /opt/wine
mkdir -p build-arm64
cd build-arm64
../configure \
    --host=aarch64-linux-gnu \
    --with-wine64=/opt/wine64/amd64 \
    --with-wine-tools=/opt/wine64/amd64/tools \
    --prefix=/usr \
    --libdir=/usr/lib/aarch64-linux-gnu 2>&1 | tee /tmp/build-logs/configure2.log

echo "构建 wine..."
make -j$(nproc) 2>&1 | tee /tmp/build-logs/make.log

echo "返回 debian 目录构建包..."
cd /opt/wine

# 使用 dpkg-buildpackage 构建
echo "使用 dpkg-buildpackage 构建 Debian 包..."
dpkg-buildpackage -d -b -a arm64 -us -uc -ui 2>&1 | tee /tmp/build-logs/dpkg-buildpackage.log

echo "构建完成!"
echo "查找生成的包..."
find /opt -name "*.deb" -type f | while read deb; do
    echo "找到包: $deb"
    cp "$deb" /opt/
done

ls -la /opt/*.deb 2>/dev/null || echo "未找到 .deb 文件"

echo "构建日志:"
ls -la /tmp/build-logs/
