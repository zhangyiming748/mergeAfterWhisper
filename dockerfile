# 使用支持 Nvidia GPU 和 CUDA 的基础镜像
# docker run -dit --name cuda --gpus all nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 bash

FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04

# 设置时区为上海
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置全局的 DEBIAN_FRONTEND 为 noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
RUN apt update &&  DEBIAN_FRONTEND=noninteractive apt full-upgrade -y &&  DEBIAN_FRONTEND=noninteractive apt install -y ffmpeg

# 指定 Go 版本
ENV GO_VERSION=1.23.5

# 安装 Go
RUN apt-get update && apt-get install -y wget && \
    wget -O go.tgz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tgz && \
    rm go.tgz

# 设置 Go 环境变量
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# 复制项目源代码
WORKDIR /go
COPY . .
RUN go mod tidy
# 来自神秘东方的代码
COPY ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct

WORKDIR /videos
# 定义入口点
CMD ["/usr/bin/merge"]