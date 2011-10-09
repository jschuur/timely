Tweetlater::Application.routes.draw do
  root :to => 'tweets#index', :as => :root

  match "auth/twitter/callback" => "sessions#create"
  match "auth/failure" => "sessions#error"
  match "signout" => "sessions#destroy", :as => :signout
  match "settings" => "users#edit", :as => :settings
  match "tweets/shorten" => "tweets#shorten", :as => :shorten_link
  match "archive" => "tweets#archive", :as => :archive

  resources :tweets, :users
end
