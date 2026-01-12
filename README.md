# Antigravity Tools 🚀

> 专业的 AI 账号管理与协议反代系统 (v3.3.20)

<div align="center">
  <img src="public/icon.png" alt="Antigravity Logo" width="120" height="120" style="border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
  <h3>您的个人高性能 AI 调度网关</h3>
  <p>
    <a href="https://github.com/suwei8/Antigravity-Manager/releases/tag/v3.3.20">
      <img src="https://img.shields.io/badge/Version-3.3.20-blue?style=flat-square" alt="Version">
    </a>
  </p>
</div>

---

## 📥 下载与安装 (Download & Install)

本版本为 **Linux ARM64** 专用 Flatpak 构建版本。

### 1. 下载安装包
点击下方链接下载 Flatpak 二进制包：

👉 **[antigravity-tools_arm64.flatpak](https://github.com/suwei8/Antigravity-Manager/releases/download/v3.3.20/antigravity-tools_arm64.flatpak)**

### 2. 部署教程 (Deployment)

#### Setp 1. 升级 Flatpak (Ubuntu 20.04 必做)
Ubuntu 20.04 默认的 Flatpak 版本过旧，会导致下载错误 (`exceeded maximum size`)。
**您必须执行以下命令升级 Flatpak**，否则无法安装。

```bash
# 1. 添加 Flatpak 官方 PPA 源
sudo add-apt-repository ppa:alexlarsson/flatpak -y

# 2. 更新并升级 Flatpak
sudo apt update && sudo apt install flatpak -y

# 3. 重启系统或重新登录 (确保路径生效)
# 这一步很重要，否则可能找不到安装的应用
```

#### Step 2. 准备环境
升级完 Flatpak 后，执行以下命令添加仓库和依赖：

```bash
# 1. 添加 Flathub 仓库源
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 2. 手动安装运行时
flatpak install --user flathub org.gnome.Platform//46 org.gnome.Sdk//46 -y
```

#### Step 3. 安装应用

在下载目录打开终端，运行以下命令进行安装：

```bash
# 安装 Flatpak 包
flatpak install --user antigravity-tools_arm64.flatpak
```

#### 4. 启动应用

安装完成后，可以通过以下命令启动应用：

```bash
flatpak run com.lbjlaq.antigravity-tools
```

---

## ⚙️ 常见问题

*   **错误：`summary exceeded maximum size`**
    请务必按照 **Setup 1** 中的步骤添加 PPA 并升级 Flatpak。这是因为旧版 Flatpak 不支持现在的 Flathub 数据量。

*   **没有图标？**
    Flatpak 安装后通常会自动注册图标。如果未在应用菜单中看到，可以尝试注销并重新登录。
