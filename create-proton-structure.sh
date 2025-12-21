#!/bin/bash
# 创建 Proton 构建所需的目录结构

# 发行版列表
DISTROS=("debian11" "debian12" "debian13" "ubuntu2004" "ubuntu2204" "ubuntu2404" "ubuntu2510")

for distro in "${DISTROS[@]}"; do
    # 确定 codename
    case $distro in
        debian11) codename="bullseye" ;;
        debian12) codename="bookworm" ;;
        debian13) codename="trixie" ;;
        ubuntu2004) codename="focal" ;;
        ubuntu2204) codename="jammy" ;;
        ubuntu2404) codename="noble" ;;
        ubuntu2510) codename="questing" ;;
    esac
    
    # 创建目录
    mkdir -p ".packaging/${distro}/proton/debian"
    mkdir -p ".packaging/${distro}/proton/patches"
    
    # 复制基础文件
    if [ ! -f ".packaging/${distro}/proton/Dockerfile" ]; then
        cp ".packaging/ubuntu2204/proton/Dockerfile" ".packaging/${distro}/proton/"
        # 更新 codename
        sed -i "s/jammy/${codename}/g" ".packaging/${distro}/proton/Dockerfile"
    fi
    
    if [ ! -f ".packaging/${distro}/proton/debian/control" ]; then
        cp ".packaging/ubuntu2204/proton/debian/control" ".packaging/${distro}/proton/debian/"
        sed -i "s/jammy/${codename}/g" ".packaging/${distro}/proton/debian/control"
    fi
    
    if [ ! -f ".packaging/${distro}/proton/debian/copyright" ]; then
        cp ".packaging/ubuntu2204/proton/debian/copyright" ".packaging/${distro}/proton/debian/"
    fi
    
    if [ ! -f ".packaging/${distro}/proton/build.sh" ]; then
        cp ".packaging/ubuntu2204/proton/build.sh" ".packaging/${distro}/proton/"
        chmod +x ".packaging/${distro}/proton/build.sh"
    fi
    
    echo "Created structure for ${distro} (${codename})"
done

echo "Directory structure created successfully!"
