Rails.application.routes.draw do
  # Home page route 
  root 'welcome#index'

  # User routes
  resources :users, only: [:show, :create, :edit, :update] do 
    # AJAX for promo code / user role setting
    post '/promo_code' => 'users#promo'
  end

  # Custom route: Dashboard for users
  get '/users/:id/dashboard' => "users#dashboard", as: 'dashboard'

  # Events routes nested with booking routes
  resources :events do 
    resources :bookings, only: [:show, :new, :edit, :create]
  end

  #Session routes
  get "/sign_in" => "sessions#new", as: "sign_in"
  post "/sign_in" => "sessions#create"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"

end
