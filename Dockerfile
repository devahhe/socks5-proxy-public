FROM ubuntu:20.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Force IPv4 to avoid IPv6 DNS hangs in Docker
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Set timezone to Africa/Maputo and install dependencies
RUN ln -fs /usr/share/zoneinfo/Africa/Maputo /etc/localtime && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        tzdata \
        dante-server \
        nodejs \
        npm \
        netcat-openbsd && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Dante config and Node proxy
COPY sockd.conf /etc/sockd.conf
COPY server.js /app/server.js
WORKDIR /app

# Start Dante, wait for it to bind, then launch Node SOCKS5 bridge
CMD ["sh", "-c", "\
  danted -f /etc/sockd.conf & \
  tail -f /var/log/sockd.log & \
  echo 'Waiting for Dante to listen on port 1080...'; \
  while ! nc -z 127.0.0.1 1080; do sleep 0.2; done; \
  echo 'Dante is ready. Launching NodeJS proxy...'; \
  node server.js"]
