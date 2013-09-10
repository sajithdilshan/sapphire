class UsersController < ApplicationController

  def oauth_failure
    flash[:error] = 'You must be logged in using Facebook to proceed.'
    redirect_to root_path
  end

end
