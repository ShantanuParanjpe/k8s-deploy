var http = require('http');
http.createServer(function(req,res){
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end('Hello World!');
}).listen(3333);
console.log('Server started on localhost:3333; press Ctrl-C to terminate...!');
