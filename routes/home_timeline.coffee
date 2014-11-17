request = require 'request'
Feed = require 'feed'
twitter = require '../twitter'
async = require 'async'

module.exports = (req, res, next) ->
	user = req.params.user
	format = req.params.format

	tweets = null
	async.parallel
		oembeds: (done) ->
			twitter.get 'statuses/home_timeline',
				screen_name: user
			, (err, timeline_data, response) ->
				return done err if err?

				tweets = timeline_data

				async.map timeline_data, (tweet, done) ->
					twitter.get 'statuses/oembed',
						id: tweet.id_str
					, done
				, done
		user: (done) ->
			twitter.get 'users/show',
				screen_name: user
			, done
	, (err, results) ->
		return next err if err?

		user = results.user[0]

		feed = new Feed
			title: "Twitter home feed for #{user.name} (@#{user.screen_name})"
			description: "" # Required in RSS
			link: "http://twitter.com/#{user.screen_name}"
			image: user.profile_image_url

		for tweet, i in tweets
			oembed = results.oembeds[i]
			feed.addItem
				title: tweet.text
				link: oembed.url
				description: oembed.html
				date: new Date tweet.created_at
				author: [
					name: "#{tweet.user.name} (@#{tweet.user.screen_name})"
					link: tweet.user.url
				]

		payload = feed.render if format is 'atom' then 'atom-1.0' else 'rss-2.0'
		res.set 'Content-Type': if format is 'atom' then 'application/atom+xml' else 'application/rss+xml'
		res.send payload
