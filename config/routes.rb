OmniauthGoogleOauth2Example::Application.routes.draw do
  get "home/index"
  root :to => 'home#index'
  match "/auth/google_login/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
