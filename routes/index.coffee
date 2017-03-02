express = require 'express'
router = express.Router()

# Routes
router.get '/user_timeline/:user(\\w{1,15})/:format(atom|rss)', require './user_timeline'
router.get '/home_timeline/:user(\\w{1,15})/:format(atom|rss)', require './home_timeline'

# Expose the router
module.exports = router
