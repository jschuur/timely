require 'net/http'

class User < ActiveRecord::Base
  has_many :tweets

  attr_accessible :email_address, :time_zone, :bitly_username, :bitly_api_key, :quick_pick_start, :quick_pick_interval
  
  def self.import_tweets
    User.all.each do |user|
      Twitter.configure do |config|
        config.consumer_key = TWITTER_KEY
        config.consumer_secret = TWITTER_SECRET
        config.oauth_token = user.twitter_token
        config.oauth_token_secret = user.twitter_secret
      end

      begin
        client = Twitter::Client.new
      rescue
      else
        user_timeline = client.user_timeline(user.twitter_handle, :count => 200,
                                             :since_id => user.tweets.imported.order(:tweet_uid).last.try(&:tweet_uid) || 1)

        user_timeline.each do |tweet|
          if user.tweets.select { |t| t.tweet_uid.to_s == tweet.id_str }.empty?
            # TODO: handle more than the first URL
            short_url = nil
            long_url= nil

            urls = Twitter::Extractor.extract_urls(tweet.text)
            if !urls.empty?
              tweet_link = urls[0]
              tweet_link = "http://#{tweet_link}" unless (tweet_link.downcase.start_with?('http://') || tweet_link.downcase.start_with?('https://'))

              if tweet_link.start_with?('http://t.co')
                urldata = tweet_link.split('/', 4)
                
                http = Net::HTTP.start(urldata[2], 80)
                response = http.head("/#{urldata[3]}")
                tweet_link = response['location']
              end
              
              urldata = tweet_link.split('/', 4)
              http = Net::HTTP.start(urldata[2], 80)
              response = http.head("/#{urldata[3]}")
              
              if [301,302].include?(response.code.to_i)
                long_url = response.header['location']
                short_url = tweet_link
              else
                long_url = tweet_link
              end
            end

            user.tweets.create(:tweet_uid => tweet.id_str.to_i, :sent_date => tweet.created_at, :status => 'imported',
                               :message => tweet.text, :short_url => short_url, :long_url => long_url)
          end
        end
      end
    end
    
  end
end
