# 使用支持 Nvidia GPU 和 CUDA 的基础镜像
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04

# 设置时区为上海
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置全局的 DEBIAN_FRONTEND 为 noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# 指定 Go 版本
ENV GO_VERSION=1.23.5

# 设置 Go 环境变量
ENV GOPATH=/go
ENV PATH=/usr/local/go/bin:${GOPATH}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 来自神秘东方的代码
COPY ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources

# 安装必要的软件包和 Go
RUN apt update && \
    apt full-upgrade -y && \
    apt install -y ffmpeg wget && \
    wget -O go.tgz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tgz && \
    rm go.tgz && \
    go env -w GO111MODULE=on && \
    go env -w GOPROXY=https://goproxy.cn,direct

# 复制项目源代码
WORKDIR ${GOPATH}/src/app
COPY . .
RUN go mod tidy

# 构建项目
RUN go build -o /usr/bin/merge

WORKDIR /videos

# 定义入口点
CMD ["/usr/bin/merge"]