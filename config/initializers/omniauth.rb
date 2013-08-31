Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
    ENV['OAUTH_CLIENT_ID'],
    ENV['OAUTH_CLIENT_SECRET'],
    {:client_options => { :proxy => ENV["HTTP_PROXY"] || ENV["http_proxy"]  },name: "google_login", approval_prompt: '',:image_aspect_ratio => "square",
      :image_size => 5, {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}}


end
