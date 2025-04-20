FROM ubuntu:20.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Force IPv4 to avoid IPv6 DNS hangs
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Set timezone to Africa/Maputo and install core dependencies
RUN ln -fs /usr/share/zoneinfo/Africa/Maputo /etc/localtime && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata \
        dante-server \
        nodejs \
        npm \
        netcat-openbsd && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Dante config
COPY sockd.conf /etc/sockd.conf

# Copy NodeJS proxy bridge
COPY server.js /app/server.js
WORKDIR /app

# Run Dante SOCKS5 server first, then start the Node bridge
CMD ["sh", "-c", "\
  danted -f /etc/sockd.conf & \
  echo 'Waiting for Dante to listen on port 1080...'; \
  while ! nc -z 127.0.0.1 1080; do sleep 0.2; done; \
  echo 'Dante is ready. Launching NodeJS proxy...'; \
  node server.js"]
