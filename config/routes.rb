Rails.application.routes.draw do
  scope '/api' do
    resources :sections
    resources :notifications
    resources :comments
    resources :document_signers
    resources :documents
    resources :folders
    resources :tasks
    resources :categories
    resources :deal_collaborators
    resources :starred_deals, only: [:create, :update, :destroy]
    resources :deals, only: [:create, :update, :destroy]
    resources :organization_users
    resources :organizations, only: [:index, :update, :destroy]

    devise_for :users,
                controllers:{
                  sessions: "sessions",
                  registrations: "registrations"
                }
  end

  root to: "home#index", as: :home
end
