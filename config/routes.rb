Tweetlater::Application.routes.draw do
  root :to => 'main#index', :as => :root

  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure" => "sessions#error"
  match "/signout" => "sessions#destroy", :as => :signout
end
