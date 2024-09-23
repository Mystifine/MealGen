const express = require('express');
const app = express();
 
exports.initiateServer = function() {
    app.get();
    http.createServer(function (req, res) {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end('aa');
      }).listen(8080);
    
  }