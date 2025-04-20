FROM ubuntu:20.04

# Set noninteractive frontend to avoid tzdata prompt
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone before installing tzdata
RUN ln -fs /usr/share/zoneinfo/Africa/Maputo /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

# Install Dante + Node.js + npm
RUN apt-get install -y dante-server nodejs npm

# Copy Dante config
COPY sockd.conf /etc/sockd.conf

# Copy Node server code
COPY server.js /app/server.js
WORKDIR /app

# No need to expose ports; Render sets $PORT dynamically
# EXPOSE 1080

# Start Dante and Node.js server
CMD ["sh", "-c", "danted -f /etc/sockd.conf & node server.js"]
