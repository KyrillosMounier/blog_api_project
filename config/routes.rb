Rails.application.routes.draw do
  post '/signup', to: 'auth#signup'
  post '/login',  to: 'auth#login'

  resources :posts do
    resources :comments, only: %i[create update destroy]
  end
end
