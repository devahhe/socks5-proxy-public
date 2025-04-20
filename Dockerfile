FROM alpine:3.18

RUN apk add --no-cache dante-server nodejs npm

COPY sockd.conf /etc/sockd.conf
COPY server.js /server.js

CMD sockd -f /etc/sockd.conf -D & node /server.js
