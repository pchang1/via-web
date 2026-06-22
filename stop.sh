#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'
INFO='\033[0;34m'
ERROR='\033[0;31m'

echo -e "${INFO}开始一键停止 Via拾光 官网服务...${NC}"

if ! docker info > /dev/null 2>&1; then
    echo -e "${ERROR}错误: Docker 未启动，无法连接容器服务。${NC}"
    exit 1
fi

echo -e "${INFO}正在停止并移除容器和网络...${NC}"
docker compose down

echo -e "${GREEN}服务已成功停止！${NC}"
