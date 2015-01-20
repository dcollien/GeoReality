globalStyles = require './common/global.less'

renderApp = require './app.cjsx'

API = require './api.coffee'

# model schema
model = {
	username: null,
	authToken: null,
	issuedAt: null,
	channel: null,
	location: null
}

# determine if the user has elected to be kept logged in
# over multiple sessions, and use the appropriate storage
if localStorage.isPersistent
	model = localStorage
else
	model = sessionStorage

# continually keep track of the browser's location
navigator.geolocation.watchPosition (position) ->
	model.location =
		latitude:  position.coords.latitude
		longitude: position.coords.longitude

window.API = new API(model, alert)

# render the app
renderApp model
