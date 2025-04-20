const net = require('net');
const LISTEN_PORT = process.env.PORT || 1080;
const DANTE_HOST = '127.0.0.1';
const DANTE_PORT = 1080;

const server = net.createServer(clientSock => {
  // Connect to Dante server for each incoming connection
  const proxySock = net.connect(DANTE_PORT, DANTE_HOST, () => {
    // Tunnel data in both directions
    clientSock.pipe(proxySock);
    proxySock.pipe(clientSock);
  });
  // Handle errors to prevent crashes
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
  console.log(`SOCKS5 proxy listening on port ${LISTEN_PORT}`);
});
