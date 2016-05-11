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
    resources :documents do
      resources :document_signers
    end
    resources :folders
    resources :tasks
    resources :categories
    devise_for :users,
                controllers:{
                  sessions: "sessions",
                  registrations: "registrations"
                }
  end
  get 'signin',      to: 'home#signin'
  get 'signup',      to: 'home#signup'
  get 'deals',       to: 'home#deals'
  get 'deals/:id',   to: 'home#deal'
  get 'team',        to: 'home#team'
  get 'team-item',   to: 'home#team_item'
  get 'deal-client', to: "home#deal_client"
  get 'deal-file',   to: "home#deal_file"
  get 'report',      to: "home#report"
  get 'setting',     to: "home#setting"

  root to: "home#index"
end
