var express = require('express');
var bodyParser = require('body-parser');
var colors = require('colors');
var app = express();


app.use( bodyParser.json() );
app.use(bodyParser.urlencoded({
	extended: true,
}));

var server = app.listen(3000, function () {
	var host = server.address().address;
	var port = server.address().port;

	console.log('Logging Server listening at http://%s:%s', host, port);
});


app.post('/', function (req, res) {
	console.log(
		"["+colors.green.underline(req.body.device)+"] "+
		req.body.time+": "+
		"("+colors.cyan(req.body.method)+") ("+req.body.file+":"+req.body.line+") "+
		req.body.message.slice(0, -1));
});
