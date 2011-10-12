class Tweet < ActiveRecord::Base
  belongs_to :user

  scope :pending, where(:status => 'pending').order(:scheduled_date)
  scope :archived, where("status != 'pending'").order("sent_date DESC")
  scope :overdue, lambda { where("scheduled_date < ? AND status='pending'", Time.now.utc) }
  scope :sent, where(:status => 'sent')

  self.per_page = 10

  def self.send_overdue_tweets
    Tweet.overdue.includes(&:user).each do |tweet|
      tweet.issue_tweet
    end
  end

  def self.update_stats(since = nil)
    if since
      tweets = Tweet.where('sent_date > ?', since)
    else
      tweets = Tweet
    end

    tweets.sent.includes(:user).group_by(&:user).each do |user, tweets|
      if user.bitly_username && user.bitly_api_key
        begin
          bitly = Bitly.new(user.bitly_username, user.bitly_api_key)
        rescue
        else
          short_urls = tweets.map(&:short_url).compact.select {|t| t.size > 0}

          # Bitly API takes up to 15 at a time
          short_urls.in_groups_of(15) do |urls|
            response = bitly.info(urls.compact)

            unless defined?(response.error)
              [response].flatten.each do |result|
                Tweet.update_all({ :user_clicks => result.user_clicks, :global_clicks => result.global_clicks }, :short_url => result.short_url)
              end
            end
          end
        end
      end
    end
  end
  
  def issue_tweet
    log = Logger.new("#{Rails.root}/log/tweets.log")

    if user
      Twitter.configure do |config|
        config.consumer_key = TWITTER_KEY
        config.consumer_secret = TWITTER_SECRET
        config.oauth_token = user.twitter_token
        config.oauth_token_secret = user.twitter_secret
      end

      begin
        client = Twitter::Client.new
        response = client.update(message)
      rescue Exception => e
        # TODO: Retry a certain number of times
        $boxcar.notify(user.email_address, "Problem sending #{user.twitter_handle} tweet '#{message}'.")
        log.error "[#{Time.now}] Unable to send tweet ID ##{id} for #{user.twitter_handle}: #{e.message}"
        update_attributes({ :status => 'error', :error => e.message })
      else
        $boxcar.notify(user.email_address, "Successfully sent #{user.twitter_handle} tweet '#{message}'.")
        log.info "[#{Time.now}] Successfully sent tweet ID ##{id} for #{user.twitter_handle}"
        update_attributes({ :status => 'sent', :tweet_uid => response.id, :sent_date => Time.now })
      end
    else
      log.error "[#{Time.now}] Invalid user ID ##{user_id} for tweet ID ##{id}"
      update_attribute(:status, 'error')
    end    
  end
end
