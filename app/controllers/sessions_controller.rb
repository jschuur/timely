class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    if user = User.find_or_initialize_by_twitter_uid(auth['uid'])
      if user.new_record?
        user.twitter_handle = auth['user_info']['nickname']
        user.twitter_token = auth['credentials']['token']
        user.twitter_secret = auth['credentials']['token']

        user.save
        new_user = true
      end

      session[:user_id] = user.id

      if new_user
        redirect_to settings_path, :notice => "Welcome #{user.twitter_handle}. Update optional settings below."
      else
        redirect_to root_path, :notice => "Logged in as #{user.twitter_handle}."
      end
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
