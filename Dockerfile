FROM ubuntu:20.04

# Prevent prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone early
RUN ln -fs /usr/share/zoneinfo/Africa/Maputo /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Install dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common curl gnupg2 && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y dante-server nodejs npm netcat-openbsd && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Dante config
COPY sockd.conf /etc/sockd.conf

# Copy Node proxy server
COPY server.js /app/server.js
WORKDIR /app

# Run Dante, wait for port 1080, then start the proxy
CMD ["sh", "-c", "\
  danted -f /etc/sockd.conf & \
  echo 'Waiting for Dante to listen on port 1080...'; \
  while ! nc -z 127.0.0.1 1080; do sleep 0.2; done; \
  echo 'Dante is ready. Starting NodeJS proxy...'; \
  node server.js"]
