# Multi-stage build for catalog service
# Stage 1: Build the Rust binary
FROM rust:1.88-slim AS builder

# Install system dependencies needed for compilation
RUN apt-get update && apt-get install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy workspace Cargo files first for dependency caching
COPY Cargo.toml Cargo.toml

# Copy all service Cargo.toml files (needed for workspace member resolution)
COPY services/shared/Cargo.toml services/shared/Cargo.toml
COPY services/api-gateway/Cargo.toml services/api-gateway/Cargo.toml
COPY services/catalog/Cargo.toml services/catalog/Cargo.toml
COPY services/worker/Cargo.toml services/worker/Cargo.toml

# Create stub files to allow cargo to cache dependencies
RUN mkdir -p services/shared/src && echo "pub fn stub() {}" > services/shared/src/lib.rs
RUN mkdir -p services/api-gateway/src && echo "fn main() {}" > services/api-gateway/src/main.rs
RUN mkdir -p services/catalog/src && echo "fn main() {}" > services/catalog/src/main.rs
RUN mkdir -p services/worker/src && echo "fn main() {}" > services/worker/src/main.rs

# Cache dependencies
RUN cargo build --release --package catalog 2>/dev/null || true

# Now copy actual source files
COPY services/shared/src services/shared/src
COPY services/catalog/src services/catalog/src
COPY services/catalog/migrations services/catalog/migrations

# Accept git SHA as build arg and pass to the build
ARG GIT_SHA=dev
ENV GIT_SHA=${GIT_SHA}

# Build the actual binary
RUN touch services/shared/src/lib.rs services/catalog/src/main.rs && \
    cargo build --release --bin catalog

# Stage 2: Minimal runtime image
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /workspace/target/release/catalog .
COPY --from=builder /workspace/services/catalog/migrations migrations/

ARG GIT_SHA=dev
ENV GIT_SHA=${GIT_SHA}

EXPOSE 8081

CMD ["./catalog"]
