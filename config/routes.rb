Rails.application.routes.draw do
  scope '/api' do
    resources :users, only: [:index]
    get '/users', to: 'users#index'
    resources :organizations do
      resources :organization_users
    end
    resources :deals do
      resources :deal_collaborators, only: [:create, :index, :destroy]
      resources :starred_deals, only: [:index, :create, :update, :destroy]
      resources :sections
    end
    resources :notifications
    resources :comments
    resources :document_signers
    resources :documents
    resources :folders
    resources :tasks
    resources :categories
    devise_for :users,
                controllers:{
                  sessions: "sessions",
                  registrations: "registrations"
                }

  end

  root to: "home#index", as: :home
end
