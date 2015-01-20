module.exports =
	'testing':
		name: 'Testing Channel'
		setter: 'test1'
		allowedUsers: [
			'test1',
			'test2',
			'test3',
			'test4'
		]
		rules:
			mode: 'collection', # go find things and collect them
			teams: # who's on what team, if there are even teams. or maybe the number of teams, and it'll be allocated automatically?
				'team1': ['test1', 'test2'],
				'team2': ['test3', 'test4']
		tags: [
			{
				name: 'tag 1',
				location:
					longitude: 0
					latitude: 0
				proximity: 10
				description: 'this is a tag'
				evidence: 'qrcode'
				limit: 1 # can only be collected once (by one player/team), then it disappears
				passphrase: 'abc123' # what's encoded on the QRCode or the passphrase that has to match
			},
			{
				name: 'tag 2',
				location:
					longitude: 0
					latitude: 0
				proximity: 20 # how close you need to be for it to register
				description: 'another tag'
				evidence: 'photo' # qrcode (scan a code), passphrase (enter the correct phrase), photo (take and share a photo), meet (must find another player)
				unlocks: ['tag3'] # does finding this tag unlock others? 
			}
		]
