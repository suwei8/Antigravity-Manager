#!/bin/bash
set -e

# Configuration
APP_ID="com.lbjlaq.antigravity-tools"
MANIFEST="build-aux/flatpak/com.lbjlaq.antigravity-tools.yml"
BUILD_DIR="flatpak-build-dir"
REPO_DIR="flatpak-repo"
DIST_DIR="distribute"
SOURCE_DIR="build-aux/flatpak/flatpak-build-source"
DEB_DIR="src-tauri/target/aarch64-unknown-linux-gnu/release/bundle/deb"

echo "=== Antigravity Tools Local Bundler ==="

# 1. Check Prerequisites
if ! command -v flatpak-builder &> /dev/null; then
    echo "Error: 'flatpak-builder' is not installed."
    echo "Please install it: sudo apt install flatpak-builder"
    exit 1
fi

if ! command -v flatpak &> /dev/null; then
    echo "Error: 'flatpak' is not installed."
    exit 1
fi

# 2. Prepare Source
echo "=> Preparing source from local .deb..."
DEB_FILE=$(find "$DEB_DIR" -name "*.deb" | head -n 1)

if [ -z "$DEB_FILE" ]; then
    echo "Error: No .deb package found in $DEB_DIR"
    echo "Please run ./local_build.sh first."
    exit 1
fi

echo "Found .deb: $DEB_FILE"
mkdir -p "$SOURCE_DIR"
# Clean previous extraction
rm -rf "$SOURCE_DIR"/*

# Extract using dpkg-deb (available on Debian/Ubuntu) or ar
if command -v dpkg-deb &> /dev/null; then
    dpkg-deb -x "$DEB_FILE" "$SOURCE_DIR"
else
    echo "Warning: dpkg-deb not found, trying ar + tar..."
    cd "$SOURCE_DIR"
    ar x "../../../$DEB_FILE"
    tar -xf data.tar.*
    rm -f debian-binary control.tar.* data.tar.*
    cd - > /dev/null
fi

# Copy bundled libs if they exist
LIBS_SOURCE="build-aux/flatpak/bundled_libs"
if [ -d "$LIBS_SOURCE" ]; then
    echo "=> Copying bundled libraries..."
    mkdir -p "$SOURCE_DIR/lib"
    cp -d "$LIBS_SOURCE"/* "$SOURCE_DIR/lib/"
fi

# 3. Install Runtimes
echo "=> Ensuring Flatpak runtimes are installed..."
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user -y flathub org.gnome.Sdk//46 org.gnome.Platform//46

# 4. Build
echo "=> Building Flatpak..."
mkdir -p "$BUILD_DIR"
flatpak-builder --user --repo="$REPO_DIR" --force-clean "$BUILD_DIR" "$MANIFEST"

# 5. Bundle
echo "=> Bundling..."
mkdir -p "$DIST_DIR"
OUTPUT_FILE="$DIST_DIR/antigravity-tools_arm64.flatpak"
flatpak build-bundle "$REPO_DIR" "$OUTPUT_FILE" "$APP_ID"

echo "=== Bundling Complete ==="
echo "Flatpak generated at: $OUTPUT_FILE"
echo "Install with: flatpak install --user $OUTPUT_FILE"
