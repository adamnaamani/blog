Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :home
  resources :now
  resources :posts, param: :slug
  resources :subscribers

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable'
  get '/500', to: 'errors#internal_server'

  get '/blog', to: 'posts#index'
  get '/:slug', to: 'posts#show'
end
