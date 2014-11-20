Feed = require 'feed'
twitter = require '../twitter'
async = require 'async'
qs = require 'qs'

module.exports = (req, res, next) ->
	user = req.params.user
	format = req.params.format

	async.parallel
		tweets: (done) ->
			twitter.get 'statuses/home_timeline',
				screen_name: user
			, done
		user: (done) ->
			twitter.get 'users/show',
				screen_name: user
			, done
	, (err, results) ->
		return next err if err?

		tweets = results.tweets[0]
		user = results.user[0]

		feed = new Feed
			title: "Twitter home feed for #{user.name} (@#{user.screen_name})"
			description: "" # Required in RSS
			link: "http://twitter.com/#{user.screen_name}"
			image: user.profile_image_url

		for tweet, i in tweets
			url = "http://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
			feed.addItem
				title: tweet.text
				link: url
				description: '<iframe border="0" frameborder="0" height="250" width="550" src="https://twitframe.com/show/?' + (qs.stringify
					url: url
					tweet: tweet.text
					author_name: tweet.user.name
					author_username: tweet.user.screen_name
					datetime: new Date(tweet.created_at).toISOString()
				) + '"></iframe>'
				date: new Date tweet.created_at
				author: [
					name: "#{tweet.user.name} (@#{tweet.user.screen_name})"
					link: tweet.user.url
				]

		payload = feed.render if format is 'atom' then 'atom-1.0' else 'rss-2.0'
		res.set 'Content-Type': if format is 'atom' then 'application/atom+xml' else 'application/rss+xml'
		res.send payload
