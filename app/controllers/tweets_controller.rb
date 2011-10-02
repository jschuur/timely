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
  end
  
  def create
    if current_user
      current_user.tweets.create(params[:tweet])
      redirect_to root_path, :notice => "New tweet scheduled."
    else
      redirect_to root_path, :alert => "You must be logged in via Twitter for that."
    end
  end

  def shorten
    begin
      (title, short_url, long_url) = shorten_url params[:url]
    rescue
      error = true
    end

    respond_with do |format|
      if error
        format.json { render :json => { :error => "Invalid URL" } }
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
    short_url = $bitly.shorten(URI.encode(url)).short_url

    [title, short_url, url]
  end
end
