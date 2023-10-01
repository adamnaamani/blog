Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :home
  resources :now
  resources :posts, param: :slug
  resources :subscribers

  get '/blog', to: 'posts#index'
  get '/:slug', to: 'posts#show'
end
