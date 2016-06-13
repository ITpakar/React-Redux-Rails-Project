Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'

  devise_for :users, skip: :all

  devise_scope :user do
    match '/api/account/sign_in',  to: 'sessions#create',      via: :post
    match '/api/account/sign_out', to: 'sessions#destroy',     via: :delete
    match '/api/users',            to: 'registrations#create', via: :post
  end

  scope "/app", module: 'app', as: :app do
    get '/dashboard', to: 'dashboard#index'
    get "/settings", to: "dashboard#settings"
    put "/settings", to: "dashboard#save_settings"

    devise_for :users

    resources :deals do
      resources :deal_collaborators, only: [:create, :index, :destroy]
      resources :starred_deals, only: [:index, :create, :update, :destroy]
      resources :sections
    end

    resources :team_members, only: [:index, :show, :update, :create, :destroy]
  end

  scope '/api', module: 'api', as: 'api' do
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
      resources :deal_collaborators, only: [:create, :index, :destroy] do
        collection do
          get 'find', to: 'deal_collaborators#find'
        end

      end
      resources :starred_deals, only: [:index, :create, :update, :destroy]
      resources :sections do
        collection do
          get :trees
        end
      end
      delete 'starred_deals', to: 'starred_deals#destroy'
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

  # Temporary routes

  root to: "app/dashboard#index"

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


  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

end
