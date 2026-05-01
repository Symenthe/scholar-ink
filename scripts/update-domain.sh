#!/bin/bash
# ============================================
# 墨韵学社 - 内网穿透域名自动更新脚本
# ============================================
# 功能：从内网穿透服务获取动态域名，写入 backend-domain.txt 并推送到 GitHub
# 用法：将此脚本设为 cron 定时任务，每隔一段时间自动执行
# ============================================

# ---------- 配置区 ----------
# GitHub 仓库配置（请修改为你的仓库地址）
REPO_DIR="$HOME/scholar-ink"
REPO_REMOTE="git@github.com:seencoloo/scholar-ink.git"
DOMAIN_FILE="backend-domain.txt"

# 内网穿透配置（以内网云 SSH 为例）
# 如果使用其他穿透工具，请修改获取域名的逻辑
TUNNEL_HOST="your-tunnel-host"
TUNNEL_PORT="your-tunnel-port"
TUNNEL_USER="your-tunnel-user"
TUNNEL_KEY="$HOME/.ssh/id_rsa"

# 日志文件
LOG_FILE="/tmp/scholar-ink-tunnel.log"
# ---------- 配置区结束 ----------

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}

log "===== 开始更新域名 ====="

# Step 1: 连接内网穿透服务，获取动态域名
# 通过 SSH 连接并捕获输出中的域名信息
# 注意：这里需要根据实际穿透工具调整
SSH_OUTPUT=$(ssh -i "$TUNNEL_KEY" -p "$TUNNEL_PORT" "$TUNNEL_USER@$TUNNEL_HOST" 2>&1 | head -50)

# Step 2: 从输出中提取域名（需要根据实际输出格式调整）
# 示例：假设输出中包含 "Your tunnel URL: xxx.xxx.xxx"
DOMAIN=$(echo "$SSH_OUTPUT" | grep -oE 'https?://[a-zA-Z0-9.-]+' | head -1)

if [ -z "$DOMAIN" ]; then
    log "错误：未能从穿透服务获取域名"
    log "SSH 输出: $SSH_OUTPUT"
    exit 1
fi

log "获取到域名: $DOMAIN"

# Step 3: 进入仓库目录
if [ ! -d "$REPO_DIR" ]; then
    log "仓库目录不存在，正在克隆..."
    git clone "$REPO_REMOTE" "$REPO_DIR" 2>&1 | tee -a "$LOG_FILE"
fi

cd "$REPO_DIR" || { log "错误：无法进入仓库目录"; exit 1; }

# Step 4: 拉取最新代码
git pull origin main 2>&1 | tee -a "$LOG_FILE"

# Step 5: 写入域名文件
echo "$DOMAIN" > "$DOMAIN_FILE"
log "域名已写入 $DOMAIN_FILE"

# Step 6: 提交并推送
git add "$DOMAIN_FILE"
git commit -m "update backend domain: $DOMAIN" 2>&1 | tee -a "$LOG_FILE"
git push origin main 2>&1 | tee -a "$LOG_FILE"

log "===== 域名更新完成 ====="
