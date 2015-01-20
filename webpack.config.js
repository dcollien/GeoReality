var webpack = require("webpack");
var BowerWebpackPlugin = require("bower-webpack-plugin");
//var UglifyJsPlugin = require("webpack/lib/optimize/UglifyJsPlugin");

module.exports = {
	entry: "./src/client/main.coffee",
	output: {
		path: __dirname + "/static",
		filename: "bundle.js"
	},
	module: {
		loaders: [
			{ test: /\.css/, loader: "style-loader!css-loader" },
			{ test: /\.less$/, loader: "style-loader!css-loader!less-loader" },
			{ test: /\.coffee$/, loader: "coffee-loader" },
			{ test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" },
			{ test: /\.cjsx$/, loader: "coffee-jsx-loader" },
			{ test: /\.jsx$/, loader: "jsx-loader?harmony" },
			{ test: /\.png/, loader: "url-loader?limit=100000&mimetype=image/png" },
			{ test: /\.gif/, loader: "url-loader?limit=100000&mimetype=image/gif" },
			{ test: /\.jpg/, loader: "file-loader" }
		]
	},
	plugins: [
		new BowerWebpackPlugin(),
		new webpack.ProvidePlugin({
			"_": "underscore"
		}),
		new webpack.ProvidePlugin({
			"$": "jquery"
		}),
		new webpack.ProvidePlugin({
			"React": "react"
		})
	],
	externals: {
		"socket.io-client": "io"
	}
}
