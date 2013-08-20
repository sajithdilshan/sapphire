OmniauthGoogleOauth2Example::Application.routes.draw do
  resources :feeditems
  resources :userfeeds
  resources :feeds
  get "home/index"
  root :to => 'home#index'
  match "/auth/google_login/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  get "show_feed_list", to: "userfeeds#show_feed_list"
end
