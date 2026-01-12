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

#### Setp 1. 准备环境 (必做)
在安装之前，您必须安装 Flatpak 并添加 Flathub 仓库源。

> **注意**: 如果您的 Flatpak 版本较旧（如 Ubuntu 20.04），可能会遇到元数据下载错误。请务必**手动安装运行时**。

在终端运行以下命令：

```bash
# 1. 安装 Flatpak (如果未安装)
sudo apt update && sudo apt install flatpak -y

# 2. 添加 Flathub 仓库源 (关键步骤！)
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 3. 手动安装依赖运行时 (解决 "runtime not found" 错误)
flatpak install --user flathub org.gnome.Platform//46 org.gnome.Sdk//46 -y
```

#### Step 2. 安装应用

在下载目录打开终端，运行以下命令进行安装：

```bash
# 安装 Flatpak 包
flatpak install --user antigravity-tools_arm64.flatpak
```
*(如果提示是否安装或导入，请输入 `y` 确认)*

#### Step 3. 启动应用

安装完成后，可以通过以下命令启动应用：

```bash
flatpak run com.lbjlaq.antigravity-tools
```

---

## ⚙️ 常见问题

*   **安装失败提示 `summary exceeded maximum size`?**
    这通常是因为 `flatpak` 版本过低。请尝试运行上面的 **"手动安装依赖运行时"** 命令来单独安装环境，然后再安装本应用。

*   **没有图标？**
    Flatpak 安装后通常会自动注册图标。如果未在应用菜单中看到，可以尝试注销并重新登录。
