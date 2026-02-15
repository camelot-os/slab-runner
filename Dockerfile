FROM ubuntu:latest AS builder

# 1) Install build dependencies (only build stage)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential ninja-build pkg-config python3 \
    python3-pip python3-venv \
    libglib2.0-dev libpixman-1-dev libslirp-dev \
    gcc-arm-none-eabi \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 2) Clone the slab-rehosting repository
WORKDIR /build
RUN git clone --recursive https://github.com/GotoHack/slab-rehosting.git slab-rehosting

# 3) Build the slab-cortex-m QEMU target
WORKDIR /build/slab-rehosting

RUN mkdir -p build && cd build && \
    ../configure --target-list=arm-softmmu --enable-debug --disable-docs && \
    ninja

# At this point the slab rehosting binary (QEMU) is at build/qemu-system-arm

# ---------- Final image (runtime only) ----------
FROM ubuntu:latest AS slab-runner

# Create directory for deployment
RUN mkdir -p /opt/slab-rehosting

# Copy only the built QEMU slab binary and any required files
# keeping build dir in order to keep non-fixed python script operationals
COPY --from=builder /build/slab-rehosting/build/qemu-system-arm /opt/slab-rehosting/build/qemu-system-arm
# add clean path aside build path
COPY --from=builder /build/slab-rehosting/build/qemu-system-arm /opt/slab-rehosting/bin/qemu-system-arm
COPY --from=builder /build/slab-rehosting/slab/python /opt/slab-rehosting/slab/python
COPY --from=builder /build/slab-rehosting/slab/boards /opt/slab-rehosting/slab/boards
COPY --from=builder /build/slab-rehosting/slab/examples/cortex-m /opt/slab-rehosting/slab/examples/cortex-m

ENV PYTHONPATH="/opt/slab-rehosting/python"
# adding qemu-system-arm slab-enabled version to the image path
ENV PATH="/opt/gtk/bin:$PATH"

# Ensure correct permissions
RUN chmod +x /opt/slab-rehosting/bin/qemu-system-arm

# Minimal runtime environment (if needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates python3 python3-pip python3-venv python3-yaml python3-intelhex \
 && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /opt/slab-rehosting

# Default CMD (can be overridden)
CMD ["/opt/slab-rehosting/qemu-system-arm", "--help"]
