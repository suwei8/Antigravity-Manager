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

### 🚀 方式 A：一键全自动安装 (推荐)

我们提供了一个自动化脚本，可以一键完成所有步骤（包括系统升级、环境配置、下载和安装）。

在终端复制并运行以下命令（需要 sudo 权限）：

```bash
wget -O install.sh https://raw.githubusercontent.com/suwei8/Antigravity-Manager/main/scripts/install.sh && chmod +x install.sh && ./install.sh
```

---

### 🛠️ 方式 B：手动分步安装

如果您更喜欢手动控制，或者脚本执行失败，请按照以下步骤操作。

#### Step 1. 升级 Flatpak (Ubuntu 20.04 必做)
如果您使用的是 Ubuntu 20.04，**必须执行**以下命令升级 Flatpak，否则无法安装。

```bash
# 1. 添加 Flatpak 官方 PPA 源
sudo add-apt-repository ppa:alexlarsson/flatpak -y

# 2. 更新并升级 Flatpak
sudo apt update && sudo apt install flatpak -y

# 3. 重启系统或重新登录 (这一步很重要，确保路径生效)
```

#### Step 2. 安装环境依赖
在终端复制并运行以下命令：

```bash
# 1. 添加 Flathub 仓库源
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 2. 安装必要的运行时环境
flatpak install --user flathub org.gnome.Platform//46 org.gnome.Sdk//46 -y
```

#### Step 3. 下载与安装

**1. 下载安装包**
```bash
wget https://github.com/suwei8/Antigravity-Manager/releases/download/v3.3.20/antigravity-tools_arm64.flatpak
```

**2. 安装应用**
```bash
flatpak install --user antigravity-tools_arm64.flatpak -y
```

#### Step 4. 启动应用
安装完成后，通过以下命令启动：

```bash
flatpak run com.lbjlaq.antigravity-tools
```

---

## ⚙️ 常见问题

*   **脚本提示 `Command not found`?**
    请确保系统已安装 `wget` 和 `sudo`。

*   **错误：`summary exceeded maximum size`**
    请务必执行 **Step 1** 升级 Flatpak。这是因为旧版 Flatpak 无法下载 Flathub 的大型索引文件。

*   **没有图标？**
    如果安装后未在应用菜单看到图标，请尝试**注销并重新登录**系统。
