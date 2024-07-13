# Use an official Debian base image
FROM debian:stable-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libusb-1.0-0-dev \
    libssl-dev \
    pkg-config \
    git \
    wget \
    python3 \
    python3-pip \
    autoconf \
    automake \
    libtool \
    snmp \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/nut

# Copy repository files into the container
COPY . /opt/nut

# Build and install NUT
RUN ./autogen.sh && \
    ./configure --with-usb --with-ssl && \
    make && \
    make install && \
    ldconfig

RUN mkdir -p /var/state/ups

# Expose the necessary ports
EXPOSE 3493

# Define entrypoint
ENTRYPOINT ["/usr/local/ups/sbin/upsd"]
