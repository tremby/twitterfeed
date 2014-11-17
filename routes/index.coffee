express = require 'express'
router = express.Router()

# Allow regex validation on route segments
router.param (name, fn) ->
	if fn instanceof RegExp
		return (req, res, next, val) ->
			if captures = fn.exec String val
				req.params[name] = String captures
				next()
			else
				next 'route'

# Route placeholders
router.param 'format', /^(?:atom|rss)$/
router.param 'user', /^\w{1,15}$/

# Routes
router.get '/user_timeline/:user/:format', require './user_timeline'
router.get '/home_timeline/:user/:format', require './home_timeline'

# Expose the router
module.exports = router
