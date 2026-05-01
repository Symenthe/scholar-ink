# 墨韵学社 (Scholar Ink)

> 以笔为舟，以数为帆 -- 初中生学习交流社区

一个面向初中生的学习社区，专注于语文作文、英语作文分享和数学压轴题解法。

## 网站架构

本项目采用 **GitHub Pages + 内网穿透** 的创新架构：

- **前端**：GitHub Pages + Jekyll（静态站点，免费托管）
- **后端**：Discuz! X5 论坛（运行在本地 PHP + MySQL 环境）
- **桥接**：内网穿透服务将本地 Discuz! 暴露到公网，动态域名存入 GitHub 仓库，前端通过 AJAX 读取

### 工作原理

```
用户访问 GitHub Pages (静态前端)
    |
    v
前端 AJAX 读取 backend-domain.txt 获取动态域名
    |
    v
通过 iframe / AJAX 连接内网穿透域名
    |
    v
请求转发到本地 Discuz! X5 (PHP + MySQL)
```

## 快速开始

### 环境要求

- Git（macOS 自带或自行安装）
- PHP 8.0+（Discuz! X5 要求）
- MySQL 8.0+
- 内网穿透工具（如内网云、cpolar 等）

### 本地运行

1. **启动 MySQL**
   ```bash
   # macOS 系统自带的 MySQL
   sudo /usr/local/mysql/support-files/mysql.server start

   # 或使用 Homebrew 安装的 MySQL
   brew services start mysql
   ```

2. **创建数据库**
   ```bash
   mysql -u root -p
   > CREATE DATABASE discuz DEFAULT CHARACTER SET utf8mb4;
   > CREATE USER 'discuz'@'localhost' IDENTIFIED BY 'discuz123';
   > GRANT ALL PRIVILEGES ON discuz.* TO 'discuz'@'localhost';
   > FLUSH PRIVILEGES;
   ```

3. **配置 Discuz!**
   - 将 Discuz! X5 源码放到 `backend/` 目录
   - 通过浏览器访问 `http://localhost:8080/install/` 进行安装
   - 按提示填写数据库信息

4. **启动 PHP 内置服务器**
   ```bash
   php -S localhost:8080 -t backend/upload/
   ```

5. **启动内网穿透**
   - 使用内网云、cpolar 等工具将 localhost:8080 暴露到公网
   - 获取分配的域名

6. **更新域名文件**
   - 将获取到的域名写入 `backend-domain.txt`
   - 推送到 GitHub 仓库

### 域名自动更新

本项目提供 `scripts/update-domain.sh` 脚本，可自动从内网穿透服务获取动态域名并推送到 GitHub：

```bash
# 修改脚本中的配置后，设置 cron 定时任务
crontab -e
# 添加：每 5 分钟执行一次
*/5 * * * * /path/to/scripts/update-domain.sh
```

## 目录结构

```
scholar-ink/
├── _config.yml          # Jekyll 配置
├── _includes/           # HTML 组件
│   ├── header.html      # 导航栏
│   └── footer.html      # 页脚
├── _layouts/            # 页面布局
│   └── default.html     # 默认布局
├── assets/              # 静态资源
│   ├── css/main.css     # 主样式表
│   ├── js/main.js       # 主脚本
│   └── images/          # 图片资源
├── scripts/             # 工具脚本
│   └── update-domain.sh # 域名自动更新脚本
├── backend-domain.txt   # 后端动态域名（自动更新）
├── index.html           # 首页
├── chinese-essays.html  # 语文作文
├── english-essays.html  # 英语作文
├── math-challenges.html # 数学压轴题
├── forum.html           # 论坛（含动态域名加载）
├── about.html           # 关于页面
├── 404.html             # 404 页面
└── README.md            # 项目说明
```

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | HTML5, CSS3, JavaScript, Jekyll |
| 样式 | 自定义 CSS (CSS Variables + Flexbox/Grid) |
| 后端论坛 | Discuz! X5 (PHP 8 + MySQL) |
| 部署 | GitHub Pages, 内网穿透 |
| 版本控制 | Git + GitHub |

## 许可证

本项目仅供学习交流使用。
