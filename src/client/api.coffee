io = require 'socket.io-client'

# connect to the server
socket = io()

class API
	constructor: (@model, logoutCallback) ->
		# callbacks for messages awaiting responses
		@callbacks = {}

		socket.on 'response', (id, data) =>
			console.log 'response', id, data
			@callbacks[id] data

		socket.on 'auth-response', (id, creds, data) =>
			console.log 'auth-response', id, creds, data

			@model.authToken = creds.authToken
			@model.issuedAt  = creds.issuedAt
			@callbacks[id] data

		socket.on 'error-response', (code) =>
			console.log 'error', code

			if code is 'logout'
				logoutCallback() if logoutCallback?
				@logout()

	logout: () ->		
		@model.username = null
		@model.authToken = null
		@model.issuedAt = null

	send: (evt, data, callback) ->
		id = Math.floor(Math.random() * 1000000000).toString(36) + Date.now().toString(36)
		creds =
			username: @model.username
			issuedAt: parseInt(@model.issuedAt, 10)
			authToken: @model.authToken
		
		@callbacks[id] = callback

		socket.emit evt, id, creds, data

	login: (username, password, callback) ->
		data = 
			username: username,
			password: password

		@send 'login', data, (result) =>
			if result isnt null
				@model.username  = username
				@model.authToken = result.authToken
				@model.issuedAt  = result.issuedAt
				callback true
			else
				callback false
	
	join: (channel, callback) -> @send 'join', channel, callback

	test: (echo, callback) -> @send 'test', echo, callback

module.exports = API