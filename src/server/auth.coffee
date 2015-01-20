crypto = require 'crypto'

checkPassword = require './testPasswords'

AUTH_SECRET = '17E4DCDCB327F89FEA26FA02FA1EA849FCCD9E5B9EA645146FA3F3C8A5137D05'

LOGOUT_ERR = 
	code: 'logout'

EXPIRES_AFTER = 2628000 # 1 month
REISSUE_AFTER = 86400/4 # 1/4 day

signCreds = (creds) ->
	hmac = crypto.createHmac 'sha256', AUTH_SECRET
	hmac.update creds.username
	hmac.update creds.issuedAt.toString(16)

	return hmac.digest('hex')

authenticate = (creds) ->
	if not creds.username? or not creds.authToken? or not creds.issuedAt?
		throw LOGOUT_ERR # invalid credentials

	currentTime = Date.now()/1000
	timeSinceIssue = (currentTime - creds.issuedAt)

	if timeSinceIssue > EXPIRES_AFTER
		throw LOGOUT_ERR # expired

	digest = signCreds creds

	if digest isnt creds.authToken
		throw LOGOUT_ERR # didn't authenticate

	# authenticated
	if timeSinceIssue > REISSUE_AFTER 
		# reissue the auth token
		creds.issuedAt = currentTime
		creds.authToken = signCreds creds

	return creds

module.exports =
	authenticate: authenticate,

	canJoinChannel: (channels, username, channel) ->
		channelData = channels[channel]
		return channelData? and (username in channelData.allowedUsers)

	login: (username, password) ->
		creds = null
		if checkPassword username, password
			creds = 
				username: username
				issuedAt: Math.floor (Date.now()/1000)

			creds.authToken = signCreds creds

		return creds

