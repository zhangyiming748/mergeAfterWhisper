FROM golang:1.23.5-bookworm AS builder
COPY . .
RUN go env -w GO111MODULE=on
RUN go build -o /usr/bin/merge merge.go

FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04

# 设置时区为上海
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置全局的 DEBIAN_FRONTEND 为 noninteractive
ENV DEBIAN_FRONTEND=noninteractive
# 来自神秘东方的代码
COPY ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources

# 安装必要的软件包
RUN apt update && \
    apt full-upgrade -y && \
    apt install -y ffmpeg wget fonts-wqy-microhei fonts-wqy-zenhei fonts-noto-cjk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 复制项目
COPY --from=builder /usr/bin/merge /usr/bin/merge
WORKDIR /videos

# 定义入口点
CMD ["/usr/bin/merge"]