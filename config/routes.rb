Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :home
  resources :now
  resources :posts do
    get :drafts, on: :collection
    post :save, on: :member
    delete :purge_attachment, on: :collection
  end
  resources :posts, param: :slug
  resources :subscribers

  get '/blog', to: 'posts#index'
  get '/drafts', to: 'posts#drafts'
  get '/:slug', to: 'posts#show'
end
