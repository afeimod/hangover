#!/bin/bash
set -e

echo "开始构建 wine64 工具依赖..."
cd /opt/wine64
mkdir -p amd64
cd amd64
../configure --enable-win64

echo "构建 __tooldeps__..."
make __tooldeps__ -j$(nproc)

echo "构建 nls 文件..."
# 确保 nls 目录存在且包含必要的文件
if [ -d nls ]; then
    echo "构建 nls 目录内容..."
    make -C nls sortdefault.nls
    if [ ! -f nls/sortdefault.nls ]; then
        echo "错误: nls/sortdefault.nls 未成功构建"
        exit 1
    fi
    echo "nls/sortdefault.nls 构建成功"
else
    echo "警告: nls 目录不存在"
fi

echo "返回主目录构建 Debian 包..."
cd /opt/wine

# 检查 changelog 格式
echo "检查 changelog 格式..."
if ! head -1 debian/changelog | grep -q "^hangover-wine ([0-9]"; then
    echo "错误: changelog 版本号不以数字开头"
    echo "当前第一行:"
    head -1 debian/changelog
    exit 1
fi

echo "开始构建 Debian 包..."
dpkg-buildpackage -d -b -a arm64 -us -uc -ui

echo "构建完成!"
ls -la /opt/*.deb

echo "移动生成的包到 /opt 目录..."
mkdir -p /opt/artifacts
mv /opt/hangover-wine_*.deb /opt/artifacts/
echo "包已移动到 /opt/artifacts/"
ls -la /opt/artifacts/
