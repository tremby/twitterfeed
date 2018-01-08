twitterfeed
===========

Simple Express app which gets a RSS/Atom feed for a particular Twitter user.

Setting up
----------

1.  Clone repository
2.  Install dependencies with `npm install`
3.  Set up environment variables with Twitter authentication information via
    - `TWITTER_CONSUMER_KEY`
    - `TWITTER_CONSUMER_SECRET`
    - `TWITTER_ACCESS_TOKEN`
    - `TWITTER_ACCESS_TOKEN_SECRET`
4.  Start server with `npm start` (or use Forever or similar)
5.  Go to `localhost:3000/user_timeline/<twitter-user-name>/atom`,
    `localhost:3000/user_timeline/<twitter-user-name>/rss`,
    `localhost:3000/home_timeline/<twitter-user-name>/atom` or
    `localhost:3000/home_timeline/<twitter-user-name>/rss`

To do
-----

- Caching
- Front page
- Other types of request
- Allow parameters?
- Refactor to reduce code repetition

Licence
-------

Assume GPL3 but ask.
