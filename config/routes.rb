Rails.application.routes.draw do
  resources :sections
  resources :notifications
  resources :comments
  resources :document_signers
  resources :documents
  resources :folders
  resources :tasks
  resources :categories
  resources :deal_collaborators
  resources :starred_deals
  resources :deals
  resources :organization_users
  resources :organizations
  devise_for :users

  root to: "home#index", as: :home
end
