APP_NAME= "Timely"

if Rails.env.development?
  TWITTER_KEY = 'd2p0K6e4xNUZituIpeNtYw'
  TWITTER_SECRET = 'mUUPI64jirJoOln5G0jTsyudT0Gs8Z5gcDB16DZEg'
else
  TWITTER_KEY = 'nS2HuAVtFGqrHOrtok6KA'
  TWITTER_SECRET = '4WQpXJjT45ov0NrEAprgSb762nFkhQvbflfDBcbhpk'
end

BOXCAR_KEY = 'rgmAM70kDnlbAs3aHBfV'
BOXCAR_SECRET = '9eg3AcLKySRwJyVPOyHKEvJma1GOleZlPAvgsiwb'

$boxcar = BoxcarAPI::Provider.new(BOXCAR_KEY, BOXCAR_SECRET)

CONTROLLER_SPECIFIC_JAVASCRIPT = %w(tweets users)

