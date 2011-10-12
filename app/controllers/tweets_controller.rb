require 'uri'
require 'open-uri'

class TweetsController < ApplicationController
  before_filter :set_timezone
  respond_to :json, :only => [ :shorten ]
  
  def index
    @tweet = Tweet.new
    if params[:url]
      (title, short_url) = shorten_url params[:url]
      
      @tweet.long_url = params[:url]
      @tweet.short_url = short_url
      @tweet.message = "#{title} #{short_url}"
    end

    package_data
  end

  def create
    if current_user
      Time.zone = current_user.time_zone

      if tweet = current_user.tweets.create(params[:tweet])      
        if params[:commit] == 'Send Now'
          tweet.update_attribute(:scheduled_date, nil)
          tweet.issue_tweet
          redirect_to root_path, :notice => "New tweet has been sent."
        else
          redirect_to root_path, :notice => "New tweet scheduled."
        end
      else
        redirect_to root_path, :alert => "Error adding new tweet."
      end
    else
      redirect_to root_path, :alert => "You must be logged in via Twitter for that."
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
    package_data
    render 'index'
  end

  def update
    @tweet = Tweet.find(params[:id])
    
    if @tweet.update_attributes(params[:tweet])
      if params[:commit] == 'Send Now'
        tweet.issue_tweet
        redirect_to root_path, :notice => "New tweet has been sent."
      else
        redirect_to root_path, :notice => "New tweet scheduled."
      end
    else
      redirect_to root_path, :alert => 'Problem updating this tweet.'
    end
  end

  def destroy
    Tweet.find(params[:id]).destroy
    redirect_to root_path
  end

  def shorten
    if current_user.bitly_username && current_user.bitly_username.size > 0 && 
       current_user.bitly_api_key && current_user.bitly_api_key.size > 0
      begin
        (title, short_url, long_url) = shorten_url params[:url]
      rescue
        error = "Unable to shorten URL."
      end
    else
      error = "Bit.ly not configured. Visit settings to enable."
    end

    respond_with do |format|
      if error
        format.json { render :json => { :error => error } }
      else
        format.json { render :json => { :title => title, :short_url => short_url, :long_url => long_url }.to_json }
      end
    end
  end
  
  def archive
    if current_user
      @archived_tweets = current_user.tweets.archived.page(params[:page])
    else
      redirect_to root_path, :alert => "You must be logged in for that."
    end
  end

  private

  def package_data
    if current_user
      @upcoming_tweets = current_user.tweets.pending

      if @upcoming_tweets.empty?
        d = Date.today + (Time.now.hour > current_user.quick_pick_start ? 1 : 0).days
        t = Time.new(d.year, d.month, d.day, current_user.quick_pick_start, 0)
      else
        t = @upcoming_tweets.last.scheduled_date + current_user.quick_pick_interval.minutes
      end

      @quickpick = t.strftime("%Y-%m-%d %I:%M%p")
    end
  end

  def shorten_url(url)
    url.insert(0, 'http://') unless (url.starts_with?('http://') || url.starts_with?('https://'))
    doc = Nokogiri::HTML(open(url))
    title = doc.at_css("title").inner_html
    
    bitly = Bitly.new(current_user.bitly_username, current_user.bitly_api_key)
    short_url = bitly.shorten(URI.encode(url)).short_url

    [title, short_url, url]
  end
  
  def set_timezone
    Time.zone = current_user.time_zone if current_user && current_user.time_zone
  end
end
