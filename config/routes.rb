Rails.application.routes.draw do
  get '/register' => 'users#new'
  get '/login' => 'session#new'
  post '/login' => 'session#create'
  post '/updateSession' => 'session#updateSession'
  delete '/logout' => 'session#destroy'
  get '/products/:id/createOrder' => "products#createOrder"
  get '/products/:id/mesProduits' => "products#mesProduits"
  get '/orders/:id/mesCommandes' => "orders#mesCommandes"

  resources :orders
  resources :products
  resources :sellers
  resources :buyers
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
