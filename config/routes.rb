Sapphire::Application.routes.draw do
  #resources :feeditems , :only => [:new, :create]
  resources :userfeeds, :only => [:refresh_feed_list,:remove_feed,:show_feed_list,:mark_feed_viewed,
                                  :mark_feed_unread,:index,:destroy]
  resources :feeds, :only => [:create]
  get 'home/index'
  root :to => 'home#index'
  match '/auth/facebook/callback' => 'sessions#create'
  match 'signout' => 'sessions#destroy', :as => :signout
  get 'show_feed_list', to: 'userfeeds#show_feed_list'
  get 'mark_feed_viewed', to: 'userfeeds#mark_feed_viewed'
  get 'mark_feed_unread', to: 'userfeeds#mark_feed_unread'
  get 'refresh_feed_list', to: 'userfeeds#refresh_feed_list'
  get 'remove_feed', to: 'userfeeds#remove_feed'
  get 'get_read_posts', to: 'userfeeds#get_read_posts'
  get 'get_unread_posts', to: 'userfeeds#get_unread_posts'
end
