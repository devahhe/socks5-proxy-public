FROM ubuntu:20.04
RUN apt-get update && apt-get install -y dante-server nodejs npm

# Copy Dante config
COPY sockd.conf /etc/sockd.conf

# Copy Node server code
COPY server.js /app/server.js
WORKDIR /app

# Expose no static port (Render sets $PORT at runtime)
# EXPOSE 1080  (no need to expose in Dockerfile for Render)

# Start Dante and Node
CMD ["sh", "-c", "danted -f /etc/sockd.conf & node server.js"]
