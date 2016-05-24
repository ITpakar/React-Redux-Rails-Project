Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'

  devise_for :users, skip: :all

  devise_scope :user do
    match '/api/account/sign_in',  to: 'sessions#create',      via: :post
    match '/api/account/sign_out', to: 'sessions#destroy',     via: :delete
    match '/api/users',            to: 'registrations#create', via: :post
  end

  scope "/app", module: 'app', as: :app do
    get '/dashboard', to: 'home#index'

    devise_scope :user do
      get '/account/sign_in', to: "sessions#new"
      post '/account/sign_in',  to: 'sessions#create'
    end

  end

  scope '/api' do
    resources :users, except: [:new, :edit]
    get    '/account', to: 'accounts#index'
    post   '/account', to: 'accounts#create'
    put    '/account', to: 'accounts#update'
    delete '/account', to: 'accounts#destroy'
    resources :organizations do
      resources :organization_users, except: [:new, :edit]
    end
    get    '/deals/starred_deals', to: 'starred_deals#starred_deals'
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
  end

  get 'signin',      to: 'app/home#signin'
  get 'signup',      to: 'app/home#signup'
  get 'deals',       to: 'app/home#deals'
  get 'deals/:id',   to: 'app/home#deal'
  get 'team',        to: 'app/home#team'
  get 'team-item',   to: 'app/home#team_item'
  get 'deal-client', to: "app/home#deal_client"
  get 'deal-file',   to: "app/home#deal_file"
  get 'report',      to: "app/home#report"
  get 'setting',     to: "app/home#setting"

  get '/docs' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')


  root to: "home#index"


end
