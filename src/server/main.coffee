express = (require 'express')
app = express()
http = (require 'http').Server app
io = (require 'socket.io')(http)

auth = require './auth'
channels = require './testChannels'

port = process.argv[2] or process.env.PORT or 8001

# set up fallback http routing (e.g. for testing)
app.use '/static', express.static process.cwd() + '/static'
app.get '/', (req, res) -> res.sendFile process.cwd() + '/index.html'

# authentication decorators
authenticated = (f, socket) ->
	return (id, creds, data) ->
		try
			auth.authenticate creds
		catch err
			if err.code?
				socket.emit 'error-response', err.code

		f.call socket, creds.username, data, (result) ->
			socket.emit 'auth-response', id, creds, result

unauthenticated = (f, socket) ->
	return (id, creds, data) ->
		f.call socket, data, (result) ->
			socket.emit 'response', id, result

# unauthenticated listeners
listeners =
	'disconnect': (socket) ->
		console.log 'client disconnected'

	'login': (data, callback) ->
		callback (auth.login data.username, data.password)

# authenticated listeners
authenticatedListeners =
	'join': (username, channel, callback) ->
		if auth.canJoinChannel channels, username, channel
			@join channel
			callback true
		else
			callback false

	'leave': (username, channel, callback) ->
		if auth.canJoinChannel channels, username, channel
			@leave channel
			callback true
		else
			callback false

	'test': (username, echo, callback) ->
		console.log echo
		callback
			echo: echo
			success: true

# register listeners
io.on 'connection', (socket) ->
	console.log 'client connected'

	for evt of listeners
		socket.on evt, (unauthenticated listeners[evt], socket)

	for evt of authenticatedListeners
		socket.on evt, (authenticated authenticatedListeners[evt], socket)

# start the server
console.log 'starting server on *:' + port
http.listen port, ->
	console.log 'listening on *:' + port

