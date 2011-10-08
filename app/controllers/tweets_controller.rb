require 'uri'
require 'open-uri'

class TweetsController < ApplicationController
  respond_to :json, :only => [ :shorten ]
  
  def index
    @tweet = Tweet.new
    if params[:url]
      (title, short_url) = shorten_url params[:url]
      
      @tweet.long_url = params[:url]
      @tweet.message = "#{title} #{short_url}"
    end

    @upcoming_tweets = current_user.tweets.pending if current_user
  end

  def create
    if current_user
      current_user.tweets.create(params[:tweet])
      redirect_to root_path, :notice => "New tweet scheduled."
    else
      redirect_to root_path, :alert => "You must be logged in via Twitter for that."
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
    render 'index'
  end

  def update

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

  private

  def shorten_url(url)
    url.insert(0, 'http://') unless (url.starts_with?('http://') || url.starts_with?('https://'))
    doc = Nokogiri::HTML(open(url))
    title = doc.at_css("title").inner_html
    
    bitly = Bitly.new(current_user.bitly_username, current_user.bitly_api_key)
    short_url = bitly.shorten(URI.encode(url)).short_url

    [title, short_url, url]
  end
end
