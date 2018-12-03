Rails.application.routes.draw do
  # Home page route 
  root 'welcome#index'

  # User route
  resources :users, only: [:show, :create, :edit, :update]

  #Session route
  get "/sign_in" => "sessions#new", as: "sign_in"
  post "/sign_in" => "sessions#create"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
end
