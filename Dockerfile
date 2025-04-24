FROM debian:stable-slim

RUN apt-get update && apt-get install -y dante-server nodejs npm curl

COPY sockd.conf /etc/sockd.conf
COPY server.js /server.js

EXPOSE 10080

CMD ["node", "/server.js"]
