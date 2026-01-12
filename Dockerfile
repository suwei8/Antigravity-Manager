# Builder stage
FROM ubuntu:20.04 AS builder

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Copy the entire src-tauri workspace 
# (We need core and server, and the workspace Cargo.toml)
# Simplified: Copy everything relevant
COPY src-tauri/ /app/src-tauri/

# Build the server
WORKDIR /app/src-tauri
# We need to make sure we are building the server package
RUN cargo build --release -p antigravity-server

# Runtime stage
FROM ubuntu:20.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash antigravity
USER antigravity
WORKDIR /home/antigravity

# Copy the binary from builder
COPY --from=builder /app/src-tauri/target/release/antigravity-server /usr/local/bin/

# Expose port
EXPOSE 3000

# Set entrypoint
CMD ["antigravity-server"]
