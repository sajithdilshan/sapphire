Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 
    ENV['OAUTH_CLIENT_ID'],
    ENV['OAUTH_CLIENT_SECRET'],
    {:client_options => { :proxy => ENV["HTTP_PROXY"] || ENV["http_proxy"]  },
      :image_size => "square", :ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'} }


end
