const http = require('http');
const port = process.env.PORT || 10080;

http.createServer((req, res) => {
  res.writeHead(200);
  res.end("SOCKS5 Proxy is running.\n");
}).listen(port, () => {
  console.log(`HTTP server listening on port ${port}`);
});
