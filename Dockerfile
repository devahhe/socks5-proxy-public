FROM alpine:3.18

RUN apk add --no-cache dante-server

COPY sockd.conf /etc/sockd.conf

CMD sockd -f /etc/sockd.conf -D
