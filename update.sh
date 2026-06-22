#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'
INFO='\033[0;34m'
ERROR='\033[0;31m'

echo -e "${INFO}开始一键更新 Via拾光 官网项目...${NC}"

if ! docker info > /dev/null 2>&1; then
    echo -e "${ERROR}错误: Docker 未启动，无法更新服务。${NC}"
    exit 1
fi

echo -e "${INFO}Step 1: 重新构建最新的 Docker 镜像...${NC}"
docker build -t via-web:latest .

echo -e "${INFO}Step 2: 重新创建并重启服务容器...${NC}"
docker compose up -d --force-recreate

echo -e "${GREEN}更新成功！最新的改动已应用。${NC}"
echo -e "${INFO}项目访问地址：http://localhost:3080/${NC}"
