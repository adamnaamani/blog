Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :home
  resources :now
  resources :posts do
    post :save, on: :member
    get :drafts, on: :collection
  end
  resources :posts, param: :slug
  resources :subscribers

  get '/blog', to: 'posts#index'
  get '/drafts', to: 'posts#drafts'
  get '/:slug', to: 'posts#show'
end
