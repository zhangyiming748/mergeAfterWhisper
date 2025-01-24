FROM golang:1.23.5-alpine3.21 AS builder
COPY . .
RUN go build -o /usr/bin/merge merge.go

# 使用支持 Nvidia GPU 和 CUDA 的基础镜像
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04

# 安装必要的软件包
RUN apt-get update && apt-get install -y ffmpeg

# 复制项目源代码
COPY --from=builder /usr/bin/merge /usr/bin/merge

WORKDIR /videos
# 定义入口点
CMD ["/usr/bin/merge"]