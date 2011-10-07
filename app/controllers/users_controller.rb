class UsersController < ApplicationController
  def edit
    redirect_to root_path, :notice => 'You must be logged in to edit your settings.' unless @user = current_user
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to root_path, :notice => 'Settings updated.'
    else
      redirect_to settings_path, :alert => 'Error updating user settings.'
    end
  end
end
