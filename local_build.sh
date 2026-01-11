#!/bin/bash
set -e

# Configuration
IMAGE_NAME="antigravity-builder:latest"
DOCKERFILE="build-aux/docker/Dockerfile"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker could not be found. Please install Docker first."
    exit 1
fi

echo "=== Antigravity Tools Local Builder ==="
echo "Target Environment: Ubuntu 22.04 (via Docker)"

# Build the builder image
echo "=> Checking/Building Docker image..."
docker build -t $IMAGE_NAME -f $DOCKERFILE .

# Detect User ID/Group ID to fix permissions later
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "=> Starting Build..."
# Mount cargo cache to verify build speed
# Using named volumes for cargo cache
docker volume create cargo_registry > /dev/null
docker volume create cargo_git > /dev/null

docker run --rm \
    -v "$(pwd):/project" \
    -v cargo_registry:/root/.cargo/registry \
    -v cargo_git:/root/.cargo/git \
    -w /project \
    -e USER_ID=$USER_ID \
    -e GROUP_ID=$GROUP_ID \
    $IMAGE_NAME \
    /bin/bash -c '
        set -e
        echo "=> [Container] Installing dependencies..."
        npm install

        echo "=> [Container] Building binary and deb package..."
        # Build for release, target aarch64-unknown-linux-gnu, only deb bundle
        npm run tauri build -- --target aarch64-unknown-linux-gnu --bundles deb
        
        echo "=> [Container] Build complete."
        
        # Packaging Flatpak is complex inside this container because we need flatpak-builder
        # which might need privileges or nested container support.
        # For now, we output the .deb which is the key artifact.
        
        echo "=> [Container] Extracting Flatpak dependency libraries..."
        mkdir -p build-aux/flatpak/bundled_libs
        cp -d /usr/lib/aarch64-linux-gnu/libayatana-appindicator3.so* build-aux/flatpak/bundled_libs/
        cp -d /usr/lib/aarch64-linux-gnu/libayatana-indicator3.so* build-aux/flatpak/bundled_libs/
        cp -d /usr/lib/aarch64-linux-gnu/libdbusmenu-gtk3.so* build-aux/flatpak/bundled_libs/
        cp -d /usr/lib/aarch64-linux-gnu/libdbusmenu-glib.so* build-aux/flatpak/bundled_libs/
        cp -d /usr/lib/aarch64-linux-gnu/libayatana-ido3-0.4.so* build-aux/flatpak/bundled_libs/

        echo "=> [Container] Fixing permissions..."
        chown -R $USER_ID:$GROUP_ID src-tauri/target node_modules build-aux/flatpak/bundled_libs
    '

echo "=== Build Finished Successfully ==="
echo "Artifacts located in: src-tauri/target/aarch64-unknown-linux-gnu/release/bundle/deb/"
