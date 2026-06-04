# Via Web — 部署指南

Via 的官网与隐私政策静态页面，基于 nginx + Docker 部署，无需任何后端服务。

---

## 页面说明

| 文件 | 路由 | 用途 |
|------|------|------|
| `index.html` | `/` | 产品主页 + App Store Support URL |
| `privacy-policy.html` | `/privacy-policy` | 隐私政策（App Store Privacy Policy URL）|

---

## 环境要求

| 软件 | 最低版本 | 说明 |
|------|----------|------|
| Docker | 20.10+ | 容器运行时 |
| Docker Compose | v2.0+ | 推荐用于管理容器生命周期（`docker compose` 命令，内置于 Docker Desktop / Docker Engine 23+）|

服务器本身**不需要**预装 nginx、Node.js 或任何其他运行时。所有依赖均打包在镜像中。

---

## 快速部署

### 方式一：本地构建（推荐首次部署）

```bash
# 1. 进入 via-web 目录
cd via-web

# 2. 构建镜像
docker build -t via-web:latest .

# 3. 启动容器
docker compose up -d

# 4. 验证
curl http://localhost/
```

访问 `http://your-server-ip/` 即可看到主页。

---

### 方式二：直接用 docker run（不需要 Compose）

```bash
docker build -t via-web:latest .

docker run -d \
  --name via-web \
  --restart unless-stopped \
  -p 5080:80 \
  via-web:latest
```

---

### 方式三：配合反向代理（Nginx / Caddy / Traefik）

如果服务器上已有其他服务占用 80/443 端口，建议将 Via Web 绑定到一个内部端口，再由反向代理转发：

**修改 `docker-compose.yml`，将端口改为内部端口（如 8080）：**

```yaml
ports:
  - "8080:80"
```

然后在你的反向代理（以 Caddy 为例）中添加：

```caddyfile
your-domain.com {
    reverse_proxy localhost:8080
}
```

Caddy 会自动申请并续期 Let's Encrypt HTTPS 证书。

---

## 常用管理命令

```bash
# 查看运行状态
docker compose ps

# 查看日志（实时）
docker compose logs -f

# 停止容器
docker compose down

# 更新内容后重新部署
docker build -t via-web:latest . && docker compose up -d --force-recreate

# 进入容器调试
docker exec -it via-web sh
```

---

## 更新内容

修改 `index.html` 或 `privacy-policy.html` 后，重新构建并重启容器即可：

```bash
docker build -t via-web:latest . && docker compose up -d --force-recreate
```

容器重启期间停机时间 < 1 秒。

---

## 目录结构

```
via-web/
  index.html            # 产品主页
  privacy-policy.html   # 隐私政策
  nginx.conf            # nginx 虚拟主机配置
  Dockerfile            # 镜像构建文件
  docker-compose.yml    # Compose 编排文件
  README.md             # 本文件
```

---

## 技术说明

- **基础镜像**：`nginx:1.27-alpine`（~10 MB），轻量安全
- **缓存策略**：HTML 文件不缓存（每次获取最新），静态资源（图片、字体等）缓存 1 年
- **安全头**：默认加入 `X-Frame-Options`、`X-Content-Type-Options`、`X-XSS-Protection`、`Referrer-Policy`
- **Gzip**：对 HTML/CSS/JS/SVG 启用压缩
- **健康检查**：容器自带 `HEALTHCHECK`，编排平台可自动重启异常容器
- **路由**：`/privacy-policy` 路由映射到 `privacy-policy.html`，无需 `.html` 后缀

---

## App Store URL 配置

部署完成后，在 App Store Connect 中填写：

| 字段 | 值 |
|------|----|
| Support URL | `https://your-domain.com/` |
| Privacy Policy URL | `https://your-domain.com/privacy-policy` |
