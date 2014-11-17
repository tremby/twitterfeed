express = require 'express'
path = require 'path'
logger = require 'morgan'

# Make sure we start in the right directory
process.chdir __dirname

# Initialize Express
app = express()

# Trust the proxy to give us the users' IP addresses
app.enable 'trust proxy'

# Decide on a logger format
app.use logger if app.get('env') is 'development' then 'dev' else 'combined'

# Use our routes
app.use '/', require './routes/index'

# Catch 404 and forward to error handler
app.use (req, res, next) ->
	err = new Error 'Not Found'
	err.status = 404
	next err

# Development error handler (with print stack trace)
if app.get('env') is 'development'
	app.use (err, req, res, next) ->
		res.status err.status or 500
		console.log err.status, err.message, err
		res.send
			status: 'error'
			message: err.message
			error: err

# Production error handler (without stack trace)
app.use (err, req, res, next) ->
	res.status err.status or 500
	res.send
		status: 'error'
		message: err.message
		error: {}

module.exports = app
