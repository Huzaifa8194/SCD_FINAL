const http = require('http');
const { exec } = require('child_process');
const path = require('path');

const PORT = process.env.PORT || 9000;
const DEPLOY_SCRIPT = path.join(__dirname, 'deploy-local.sh');

const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/deploy') {
    console.log('Received deployment webhook');
    
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    
    req.on('end', () => {
      try {
        const payload = JSON.parse(body);
        console.log('Deployment payload:', payload);
        
        // Execute the deployment script
        console.log('Executing deployment script:', DEPLOY_SCRIPT);
        exec(`bash ${DEPLOY_SCRIPT}`, (error, stdout, stderr) => {
          if (error) {
            console.error(`Deployment error: ${error}`);
            return;
          }
          console.log(`Deployment output: ${stdout}`);
          if (stderr) {
            console.error(`Deployment stderr: ${stderr}`);
          }
        });
        
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'success', message: 'Deployment triggered' }));
      } catch (error) {
        console.error('Error processing webhook:', error);
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ status: 'error', message: error.message }));
      }
    });
  } else {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'error', message: 'Not found' }));
  }
});

server.listen(PORT, () => {
  console.log(`Webhook server listening on port ${PORT}`);
  console.log(`Ready to receive deployment notifications at http://localhost:${PORT}/deploy`);
}); 