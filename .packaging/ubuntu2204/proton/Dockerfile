# 基于之前构建的基础镜像
FROM foundationubuntu2204

# 设置环境变量
ENV HOVERSION=0.0.0
ENV PROTON_VERSION=8.0
ENV DEBIAN_FRONTEND=noninteractive
ENV BUILD_JOBS=$(nproc)

# 安装 Proton 构建依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    meson \
    nasm \
    flex \
    bison \
    gettext \
    texinfo \
    git \
    python3 \
    python3-pip \
    python3-setuptools \
    libfreetype-dev \
    libfontconfig-dev \
    libx11-dev \
    libxext-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libxcomposite-dev \
    libxdamage-dev \
    libxfixes-dev \
    libxxf86vm-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libvulkan-dev \
    libpulse-dev \
    libdbus-1-dev \
    libsdl2-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libopenal-dev \
    libpcap-dev \
    libudev-dev \
    libusb-1.0-0-dev \
    libv4l-dev \
    libxkbcommon-dev \
    libxml2-dev \
    libxslt1-dev \
    libasound2-dev \
    libgnutls28-dev \
    libldap2-dev \
    libmpg123-dev \
    libcups2-dev \
    libsane-dev \
    libkrb5-dev \
    libgssapi-krb5-2 \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libavutil-dev \
    libavfilter-dev \
    libpostproc-dev \
    libtheora-dev \
    libvpx-dev \
    libspeex-dev \
    libopus-dev \
    libwebp-dev \
    libgsm1-dev \
    liblcms2-dev \
    libtiff-dev \
    libgphoto2-dev \
    libopenexr-dev \
    libheif-dev \
    libraw-dev \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    libp11-kit-dev \
    libsecret-1-dev \
    libsoup2.4-dev \
    libgstreamer-plugins-bad1.0-dev \
    libgstreamer-plugins-good1.0-dev \
    libssl-dev \
    libc6-dev \
    libgcc-11-dev \
    libstdc++-11-dev \
    && rm -rf /var/lib/apt/lists/*

# 创建工作目录
WORKDIR /opt/proton-build

# 复制源代码
COPY . /opt/proton-build

# 创建构建目录
RUN mkdir -p build

# 配置和构建 Proton
RUN cd build && \
    ../configure \
        --prefix=/opt/proton \
        --enable-win64 \
        --disable-win16 \
        --disable-tests \
        --with-x \
        --with-gstreamer \
        --with-openal \
        --with-vulkan \
        --with-mingw \
        CFLAGS="-O2 -pipe" \
        CXXFLAGS="-O2 -pipe" && \
    make -j${BUILD_JOBS} && \
    make install

# 为 Debian 包创建目录结构
RUN mkdir -p /opt/deb-package/DEBIAN \
    /opt/deb-package/opt/hangover-proton \
    /opt/deb-package/usr/bin \
    /opt/deb-package/usr/share/applications \
    /opt/deb-package/usr/share/icons/hicolor/256x256/apps

# 复制文件到包目录
RUN cp -r /opt/proton/* /opt/deb-package/opt/hangover-proton/

# 创建启动脚本
RUN cat > /opt/deb-package/usr/bin/hangover-proton << 'EOF'
#!/bin/bash
PROTON_DIR="/opt/hangover-proton"
export PATH="${PROTON_DIR}/bin:${PATH}"
export LD_LIBRARY_PATH="${PROTON_DIR}/lib:${LD_LIBRARY_PATH}"
export WINEPREFIX="${WINEPREFIX:-${HOME}/.hangover-proton}"
exec "${PROTON_DIR}/bin/wine" "$@"
EOF

RUN chmod +x /opt/deb-package/usr/bin/hangover-proton

# 创建桌面文件
RUN cat > /opt/deb-package/usr/share/applications/hangover-proton.desktop << EOF
[Desktop Entry]
Name=Hangover Proton
Comment=Proton ${PROTON_VERSION} for Hangover ${HOVERSION}
Exec=hangover-proton %u
Icon=hangover-proton
Terminal=false
Type=Application
Categories=Utility;Emulator;
MimeType=application/x-ms-dos-executable;application/x-msi;application/x-ms-shortcut;
EOF

# 复制控制文件
COPY debian/control /opt/deb-package/DEBIAN/
COPY debian/copyright /opt/deb-package/DEBIAN/

# 生成 md5sums
RUN cd /opt/deb-package && \
    find . -type f ! -path "./DEBIAN/*" -exec md5sum {} \; > DEBIAN/md5sums

# 设置权限
RUN chmod -R 755 /opt/deb-package/DEBIAN

# 构建 Debian 包
RUN dpkg-deb --build /opt/deb-package /opt/hangover-proton_${HOVERSION}~jammy_arm64.deb

# 输出最终位置
RUN echo "Package built at: /opt/hangover-proton_${HOVERSION}~jammy_arm64.deb"
