const net = require('net');

const LISTEN_PORT = process.env.PORT || 10080; // Render assigns this dynamically
const DANTE_HOST = '127.0.0.1';
const DANTE_PORT = 1080;

const server = net.createServer(clientSock => {
  const proxySock = net.connect(DANTE_PORT, DANTE_HOST, () => {
    clientSock.pipe(proxySock);
    proxySock.pipe(clientSock);
  });

  proxySock.on('error', err => {
    console.error('Dante socket error:', err.message);
    clientSock.destroy();
  });

  clientSock.on('error', err => {
    console.error('Client socket error:', err.message);
    proxySock.destroy();
  });
});

server.listen(LISTEN_PORT, '0.0.0.0', () => {
  console.log(`SOCKS5 bridge listening on ${LISTEN_PORT}`);
});
