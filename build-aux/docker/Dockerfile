FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    build-essential \
    libwebkit2gtk-4.1-dev \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev \
    patchelf \
    pkg-config \
    libsoup-3.0-dev \
    javascriptcoregtk-4.1 \
    libjavascriptcoregtk-4.1-dev \
    libnm-dev \
    xdg-utils \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add aarch64 target (assuming we are building for arm64 as per user request/env)
RUN rustup target add aarch64-unknown-linux-gnu

WORKDIR /project

# Prepare entrypoint
CMD ["/bin/bash"]
