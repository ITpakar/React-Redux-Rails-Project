Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  devise_for :users, skip: :all
  devise_scope :user do
    get   '/app/account/sign_in',  to: "sessions#new"
    match '/api/account/sign_in',  to: 'sessions#create',      via: :post
    post '/app/account/sign_in',  to: 'sessions#create'
    match '/api/account/sign_out', to: 'sessions#destroy',     via: :delete
    match '/api/users',            to: 'registrations#create', via: :post
  end

  scope "/app" do
    get '/dashboard', to: 'home#index'  
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

  get '/docs' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')


  root to: "home#index"


end
