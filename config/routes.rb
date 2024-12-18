Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :home
  resources :nows
  resources :posts do
    get :drafts, on: :collection
    post :save, on: :member
    post :upload, on: :member
    delete :purge_attachment, on: :collection
  end
  resources :posts, param: :slug
  resources :subscribers
  resources :uploads do
    delete :purge_attachment, on: :collection
  end

  get "up", to: "rails/health#show", as: :rails_health_check
  get "/blog", to: "posts#index"
  get "/drafts", to: "posts#drafts"
  get "/:slug", to: "posts#show"
end
