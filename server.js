const http = require("http");
const { spawn } = require("child_process");

const port = process.env.PORT || 10080;

const server = http.createServer((_, res) => {
  res.writeHead(200);
  res.end("SOCKS5 proxy is running\n");
});

server.listen(port, () => {
  console.log(`HTTP server listening on port ${port}`);

  const sockd = spawn("sockd", ["-f", "/etc/sockd.conf"]);
  sockd.stdout.on("data", (data) => console.log(data.toString()));
  sockd.stderr.on("data", (data) => console.error(data.toString()));
});
