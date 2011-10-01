class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    if user = User.find_or_create_by_twitter_uid(auth['uid'], { :twitter_handle => auth['user_info']['nickname'],
                                                                :twitter_token => auth['credentials']['token'],
                                                                :twitter_secret => auth['credentials']['token'] })
      session[:user_id] = user.id

      redirect_to root_path, :notice => "Logged in as #{user.twitter_handle}."
    else
      redirect_to root_path, :alert => "Unable to log you in."
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path, :notice => "You've been logged out."
  end

  def error
    redirect_to root_path, :alert => "Unable to connect via authentication provider."
  end
end
