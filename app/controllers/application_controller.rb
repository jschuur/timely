class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :access_token_login

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def access_token_login
    if params[:access_token] && user = User.find_by_access_token(params[:access_token])
      @current_user = user
      session[:user_id] = user.id

      querystring = request.env['QUERY_STRING'].split('&').delete_if { |x| x.starts_with?'access_token' }.join('&')

      redirect_to "#{request.env['PATH_INFO']}#{ "?" + querystring if querystring.size > 0}"
    end
  end
end
