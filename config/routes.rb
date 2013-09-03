Sapphire::Application.routes.draw do
  resources :feeditems
  resources :userfeeds
  resources :feeds
  get "home/index"
  root :to => 'home#index'
  match "/auth/facebook/callback" => "sessions#create"
  match "signout" => "sessions#destroy", :as => :signout
  get "show_feed_list", to: "userfeeds#show_feed_list"
  get "mark_feed_viewed", to: "userfeeds#mark_feed_viewed"
  get "mark_feed_unread", to: "userfeeds#mark_feed_unread"
  get "refresh_feed_list", to: "userfeeds#refresh_feed_list"
  get "remove_feed", to: "userfeeds#remove_feed"
end
