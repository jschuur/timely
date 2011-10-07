Tweetlater::Application.routes.draw do
  root :to => 'tweets#index', :as => :root

  resources :users

  match "auth/twitter/callback" => "sessions#create"
  match "auth/failure" => "sessions#error"
  match "signout" => "sessions#destroy", :as => :signout
  match "settings" => "users#edit", :as => :settings
  
  match "tweets/create" => "tweets#create", :as => :tweets
  match "tweets/shorten" => "tweets#shorten", :as => :shorten_link
end
