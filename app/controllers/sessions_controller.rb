class SessionsController < ApplicationController

  skip_before_filter :login_required
  def create
    puts '*********************creating user******************************'
    auth = request.env['omniauth.auth']
    user = User.where(:provider => auth['provider'], :uid => auth['uid']).first_or_initialize(
      :refresh_token => auth['credentials']['refresh_token'],
      :access_token => auth['credentials']['token'],
      :expires => auth['credentials']['expires_at'],
      :name => auth['info']['name'],
      :profile_pic => auth['info']['image']
    )
    url = session[:return_to] || root_path
    session[:return_to] = nil
    url = root_path if url.eql?('/logout')

    if user.save
      puts '*********************************saving user**************************'
      session[:user_id] = user.id
      logger.debug "URL to redirect to: #{url}"
      # raise env["omniauth.auth"].to_yaml
      Delayed::Job.enqueue UpdateFeed.new(current_user.uid)
      redirect_to userfeeds_path
    else
      flash[:error] = 'You must be logged in to view this page.'
      redirect_to root_path
      #raise 'Failed to login'
    end
  end

  
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
