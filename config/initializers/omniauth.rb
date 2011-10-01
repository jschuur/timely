Rails.application.config.middleware.use OmniAuth::Builder do
  # Get your credentials from http://dev.twitter.com
  if Rails.env.development?
    provider :twitter, 'd2p0K6e4xNUZituIpeNtYw', 'mUUPI64jirJoOln5G0jTsyudT0Gs8Z5gcDB16DZEg'
  else
    provider :twitter, '', ''
  end
end
