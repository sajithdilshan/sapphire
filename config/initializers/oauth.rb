Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
    ENV['OAUTH_CLIENT_ID'],
    ENV['OAUTH_CLIENT_SECRET'],
    {name: "google_login", approval_prompt: '',:image_aspect_ratio => "square",
      :image_size => 25}


end
