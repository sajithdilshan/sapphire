class HomeController < ApplicationController
    skip_before_filter :login_required

  
  def index
    if current_user
      redirect_to userfeeds_path
    end
  end
end
