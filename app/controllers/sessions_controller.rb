class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    if user = User.find_or_initialize_by_twitter_uid(auth['uid'])
      if user.new_record?
        new_user = true

        user.twitter_handle = auth['user_info']['nickname']
        user.time_zone = auth['extra']['user_hash']['time_zone']
        user.access_token = ActiveSupport::SecureRandom::hex(32)
      end

      user.twitter_token = auth['credentials']['token']
      user.twitter_secret = auth['credentials']['secret']
      user.save

      session[:user_id] = user.id

      if new_user
        redirect_to settings_path, :notice => "Welcome #{user.twitter_handle}. Update optional settings below."
      else
        redirect_to root_path
      end
    else
      redirect_to root_path, :alert => "Unable to log you in."
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  def error
    redirect_to root_path, :alert => "Unable to connect via authentication provider."
  end
end
