Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/healthcheck', to: proc { [200, {}, ['OK']] }
  namespace :v1 do
    post 'login', to: 'auth#login'
    resources :videos, only: %i[index create show]
  end
end
