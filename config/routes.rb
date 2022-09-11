Rails.application.routes.draw do
  #resources :users
  post '/users', to: "users#get_auth_token"
  post '/auth', to: "users#test_token"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
