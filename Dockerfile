FROM debian:stable-slim

RUN apt-get update && apt-get install -y dante-server nodejs curl

COPY sockd.conf /etc/sockd.conf
COPY server.js /server.js

EXPOSE 10080

ENTRYPOINT ["node", "/server.js"]
