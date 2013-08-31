OmniauthGoogleOauth2Example::Application.routes.draw do
  get "/auth/google_login/callback", to: "sessions#create"
  match "signout" => "sessions#destroy", :as => :signout
  resources :feeditems
  resources :userfeeds
  resources :feeds
  get "home/index"
  root :to => 'home#index'
  get "show_feed_list", to: "userfeeds#show_feed_list"
  get "mark_feed_viewed", to: "userfeeds#mark_feed_viewed"
  get "mark_feed_unread", to: "userfeeds#mark_feed_unread"
end
