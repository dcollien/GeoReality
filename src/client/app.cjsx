NavBar = require './components/navbar.cjsx'

module.exports = (model) ->
	React.render <NavBar model={model}/>, document.body
