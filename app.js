var express = require('express');
var app = express();
var path = require('path');
var port = 80;

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname + '/public/index.html'));
});

app.use(express.static('public'))

app.listen(port,() => console.log(`App listening on port ${port}!`));