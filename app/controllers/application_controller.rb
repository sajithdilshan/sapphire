class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :login_required


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def max_post_size
    10
  end

  def login_required
    unless current_user 
        flash[:error] = 'You must be logged in to view this page.'  
        redirect_to root_path
      end 
  end
end
