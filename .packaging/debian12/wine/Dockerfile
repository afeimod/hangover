FROM foundationdebian12

ARG LLVMMINGW_NAME=llvm-mingw-20251202-ucrt-ubuntu-22.04-x86_64
ENV LLVMMINGW_PATH="/opt/$LLVMMINGW_NAME/bin"

RUN rm -rf /opt/wine; mkdir -p /opt/wine/
COPY ./ /opt/wine/
RUN ls -la /opt/wine/
RUN cp -ra /opt/wine /opt/wine64
ENV PATH="$LLVMMINGW_PATH:$PATH"

# 构建 64 位 wine 作为工具链
RUN cd /opt/wine64; mkdir -p amd64; cd amd64; ../configure --enable-win64
RUN cd /opt/wine64/amd64; make __tooldeps__ -j$(nproc)
RUN cd /opt/wine64/amd64; make -C nls

# 创建符号链接，确保工具链可访问
RUN ln -sf /opt/wine64/amd64/tools /opt/wine/tools
RUN ln -sf /opt/wine64/amd64/nls /opt/wine/nls

# 复制构建脚本
COPY build.sh /opt/wine/build.sh
RUN chmod +x /opt/wine/build.sh

# 执行构建
RUN cd /opt/wine && ./build.sh
