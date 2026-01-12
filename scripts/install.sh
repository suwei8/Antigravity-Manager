#!/bin/bash
set -e

# Configuration
VERSION="v3.3.20"
DOWNLOAD_URL="https://github.com/suwei8/Antigravity-Manager/releases/download/${VERSION}/antigravity-tools_arm64.flatpak"
FILE_NAME="antigravity-tools_arm64.flatpak"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Antigravity Tools One-Click Installer (${VERSION}) ===${NC}"
echo -e "${BLUE}OS Check: Ubuntu/Debian system detected.${NC}"

# Check for sudo
if [ "$EUID" -ne 0 ] && ! command -v sudo &> /dev/null; then
  echo -e "${RED}Error: This script requires sudo privileges to update system packages.${NC}"
  exit 1
fi

# 1. Update Flatpak (Ubuntu 20.04 Fix)
echo -e "\n${GREEN}[1/5] Updating Flatpak environment...${NC}"
echo "Adding official Flatpak PPA to ensure we have a supported version..."
sudo add-apt-repository ppa:alexlarsson/flatpak -y
sudo apt-get update
sudo apt-get install flatpak -y

# 2. Configure Flathub
echo -e "\n${GREEN}[2/5] Configuring Flathub repository...${NC}"
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 3. Install Runtimes
echo -e "\n${GREEN}[3/5] Installing Runtime Dependencies (GNOME 46)...${NC}"
flatpak install --user flathub org.gnome.Platform//46 org.gnome.Sdk//46 -y

# 4. Download Application
echo -e "\n${GREEN}[4/5] Downloading Application...${NC}"
if [ -f "$FILE_NAME" ]; then
    echo "Found existing file, removing..."
    rm "$FILE_NAME"
fi
wget -O "$FILE_NAME" "$DOWNLOAD_URL"

# 5. Install Application
echo -e "\n${GREEN}[5/5] Installing Antigravity Tools...${NC}"
flatpak install --user "$FILE_NAME" -y

# Cleanup
rm "$FILE_NAME"

echo -e "\n${GREEN}=== Installation Complete! 🎉 ===${NC}"
echo -e "You can now launch the app using:"
echo -e "${BLUE}flatpak run com.lbjlaq.antigravity-tools${NC}"
echo -e "Note: If you don't see the icon, try logging out and back in."
