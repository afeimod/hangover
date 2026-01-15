FROM foundationdebian12

ARG LLVMMINGW_NAME=llvm-mingw-20251202-ucrt-ubuntu-22.04-x86_64
ENV LLVMMINGW_PATH="/opt/$LLVMMINGW_NAME/bin"

RUN rm -rf /opt/wine; mkdir -p /opt/wine/
COPY ./ /opt/wine/
RUN ls -la /opt/wine/
RUN cp -ra /opt/wine /opt/wine64
ENV PATH="$LLVMMINGW_PATH:$PATH"

# 复制构建脚本
COPY build.sh /opt/wine/build.sh
RUN chmod +x /opt/wine/build.sh

# 执行构建
RUN cd /opt/wine && ./build.sh
