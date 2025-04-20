const http = require('http');
const { exec } = require('child_process');

// Render requires a visible HTTP server on this port
const port = process.env.PORT || 10080;

// Start Dante on SOCKS5 port 1080
exec('sockd -f /etc/sockd.conf');

http.createServer((req, res) => {
  res.writeHead(200);
  res.end('SOCKS5 Proxy running on port 1080\n');
}).listen(port, () => {
  console.log(`HTTP server listening on port ${port}`);
});
