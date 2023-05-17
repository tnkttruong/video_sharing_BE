Rails.application.routes.draw do
  namespace :v1 do
    post 'login', to: 'auth#login'
  end
end
