Rails.application.routes.draw do
  namespace :v1 do
    post 'login', to: 'auth#login'
    resources :videos, only: %i[index create]
  end
end
