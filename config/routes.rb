Rails.application.routes.draw do
  resources :categories
  resources :deal_collaborators
  resources :deals
  resources :organization_users
  resources :organizations
  devise_for(
    :users
  )
  root to: "home#index", as: :home
end
