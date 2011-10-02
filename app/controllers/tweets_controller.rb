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
    (title, short_url) = shorten_url params[:url]

    respond_with do |format|
      format.json { render :json => { :title => title, :short_url => short_url }.to_json }
    end
  end

  private

  def shorten_url(url)
    doc = Nokogiri::HTML(open(url))
    title = doc.at_css("title").inner_html
    short_url = $bitly.shorten(url).short_url

    [title, short_url]
  end
end
