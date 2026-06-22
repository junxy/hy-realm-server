#!/bin/bash

export CGO_ENABLED=0
export GOOS=linux
export GOARCH=amd64

set -e

#
# # 1. 获取当前的编译时间（符合 ISO 8601 标准）
# BUILD_TIME=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILD_TIME=$(date +"%Y-%m-%d %H:%M:%S %z")

# 2. 获取当前的 Git 版本号（如果没有打 tag，会自动显示 commit hash）
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "v0.0.1")

# 3. 执行编译，通过 -X 将值塞给 main 包下的变量
# go build -ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}" -o myapp-binary main.go
XVER="-X 'main.Version=${VERSION}' -X 'main.BuildTime=${BUILD_TIME}'"

echo $XVER

go build -trimpath -ldflags="-s -w $XVER" -o dist/hysteria-realm-server-linux-$GOARCH-3

# scp hysteria-realm-server-linux-$GOARCH-3 rn-01-loc:/opt/projects/hysteria-realm-server/bin

# rsync --version
rsync -avz --progress dist/hysteria-realm-server-linux-$GOARCH-3 rn-01-loc:/opt/projects/hysteria-realm-server/bin
