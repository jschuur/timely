Rails.application.config.middleware.use OmniAuth::Builder do
  # Get your credentials from http://dev.twitter.com
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
end
