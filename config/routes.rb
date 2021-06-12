Rails.application.routes.draw do
  root 'home#index'

  get '/login', to: 'login#new'
  post '/login', to: 'login#create'
  delete '/logout', to: 'login#destroy'
end
