FROM ubuntu:20.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone to Africa/Maputo
RUN ln -fs /usr/share/zoneinfo/Africa/Maputo /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Install Dante SOCKS5 server, Node.js, npm, and netcat for port check
RUN apt-get install -y dante-server nodejs npm netcat

# Copy Dante config
COPY sockd.conf /etc/sockd.conf

# Copy Node proxy script
COPY server.js /app/server.js
WORKDIR /app

# Start Dante in background, wait for port 1080, then start Node proxy
CMD ["sh", "-c", "\
  danted -f /etc/sockd.conf & \
  echo 'Waiting for Dante to listen on port 1080...'; \
  while ! nc -z 127.0.0.1 1080; do sleep 0.2; done; \
  echo 'Dante is ready. Launching NodeJS proxy...'; \
  node server.js"]
