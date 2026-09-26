# syntax=docker/dockerfile:1

# ==============================================================================
# Stage 1: Build RADMC-3D binary
# ==============================================================================
FROM alpine:3.20 AS builder

RUN apk add --no-cache \
    build-base \
    gfortran \
    make

WORKDIR /build

# Copy only the source directory from the submodule
COPY radmc3d-2.0/src/ /build/

# Compile with OpenMP and strip debug symbols to minimize binary size
RUN make clean && \
    make && \
    strip radmc3d

# ==============================================================================
# Stage 2: Minimal runtime container
# ==============================================================================
FROM alpine:3.20

LABEL org.opencontainers.image.title="RADMC-3D" \
      org.opencontainers.image.description="Lightweight Docker image for RADMC-3D radiative transfer package" \
      org.opencontainers.image.url="https://github.com/Radonirinaunimi/radmc3d-docker" \
      org.opencontainers.image.source="https://github.com/Radonirinaunimi/radmc3d-docker" \
      org.opencontainers.image.licenses="GPL-2.0"

# Install Fortran runtime and OpenMP support
RUN apk add --no-cache \
    libgfortran \
    libgomp

# Ensure sufficient stack size for OpenMP threads
ENV OMP_STACKSIZE=64M

# Copy compiled executable and entrypoint script
COPY --from=builder /build/radmc3d /usr/local/bin/radmc3d
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /work

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["radmc3d"]
