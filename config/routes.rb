Rails.application.routes.draw do
  #resources :users
  post '/auth', to: "tokens#get_auth_token"
  post '/auth/refresh', to: "tokens#test_token"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
