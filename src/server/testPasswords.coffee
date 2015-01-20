DUMMY_CREDENTIALS =
	'test1': 'password1',
	'test2': 'password2',
	'test3': 'password3',
	'test4': 'password4'

module.exports = (username, password) ->
	return DUMMY_CREDENTIALS[username] is password
