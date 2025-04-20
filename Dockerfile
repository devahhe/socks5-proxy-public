FROM ubuntu:20.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Use faster mirror and set timezone
RUN sed -i 's|http://archive.ubuntu.com|http://mirror.ubuntu.com|g' /etc/apt/sources.list && \
    ln -fs /usr/share/zoneinfo/Africa/Maputo /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Install required packages (Dante SOCKS5, Node.js, npm, netcat)
RUN apt-get update && \
    apt-get install -y dante-server nodejs npm netcat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Dante config
COPY sockd.conf /etc/sockd.conf

# Copy Node.js proxy wrapper
COPY server.js /app/server.js
WORKDIR /app

# Start Dante in background and wait for port 1080 to be open before Node starts
CMD ["sh", "-c", "\
  danted -f /etc/sockd.conf & \
  echo 'Waiting for Dante to listen on port 1080...'; \
  while ! nc -z 127.0.0.1 1080; do sleep 0.2; done; \
  echo 'Dante is ready. Launching NodeJS proxy...'; \
  node server.js"]
