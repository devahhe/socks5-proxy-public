const { spawn } = require('child_process');

const sockd = spawn('sockd', ['-f', '/etc/sockd.conf']);

sockd.stdout.on('data', data => {
  console.log(`[SOCKD STDOUT]: ${data}`);
});
sockd.stderr.on('data', data => {
  console.error(`[SOCKD STDERR]: ${data}`);
});
sockd.on('close', code => {
  console.log(`sockd exited with code ${code}`);
});
