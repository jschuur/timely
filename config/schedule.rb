# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# set :output, "/path/to/my/cron_log.log"

every 2.minutes do
  runner "Tweet.send_tweets"
end

every 30.minutes do
  runner "Tweet.update_stats(1.week.ago)"
end

every 1.day do
  runner "Tweet.update_stats"
end