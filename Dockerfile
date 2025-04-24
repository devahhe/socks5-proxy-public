FROM debian:stable-slim

# Install dependencies for building Dante SOCKS5 from source
RUN apt-get update && \
    apt-get install -y gcc make wget curl nodejs npm

# Download and build Dante SOCKS5
RUN wget https://www.inet.no/dante/files/dante-1.4.2.tar.gz && \
    tar -xvzf dante-1.4.2.tar.gz && \
    cd dante-1.4.2 && \
    ./configure && make && make install

# Add config and startup script
COPY sockd.conf /etc/sockd.conf
COPY server.js /server.js

EXPOSE 10080

ENTRYPOINT ["node", "/server.js"]
