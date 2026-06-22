#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color
INFO='\033[0;34m'
ERROR='\033[0;31m'

echo -e "${INFO}开始一键部署 Via拾光 官网项目...${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${ERROR}错误: Docker 守护进程未启动，请先开启 Docker。${NC}"
    exit 1
fi

# Build image
echo -e "${INFO}Step 1: 构建 Docker 镜像...${NC}"
docker build -t via-web:latest .

# Deploy container
echo -e "${INFO}Step 2: 启动容器服务...${NC}"
docker compose up -d

# Status check
echo -e "${GREEN}部署成功！服务正在后台运行。${NC}"
echo -e "${INFO}项目访问地址：http://localhost:3080/${NC}"
