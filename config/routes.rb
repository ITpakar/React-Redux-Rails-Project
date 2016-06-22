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
    get "/report", to: "reports#show"

    match "/docusign_hook/", to: "docusign_webhook#update", as: :docusign_webhook, via: [:get, :post]

    devise_for :users

    resources :deals do
      resources :deal_collaborators, only: [:create, :index, :destroy]
      resources :starred_deals, only: [:index, :create, :update, :destroy]
      resources :sections

      member do
        get 'diligence', to: "deals#diligence", as: :diligence
        get 'closing', to: "deals#closing", as: :closing
        get 'closing-book', to: "deals#closing_book", as: :closing_book
        post 'closing-book', to: "deals#create_closing_book"
      end
    end

    resources :team_members, only: [:index, :show, :update, :create, :destroy]
    resources :documents, :only => [:show]
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
      collection do
        get :summary
      end

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
      member do
    	   post :versions, :to => "documents#create_version"
      end

      resources :document_signers
    end
    post 'documents/:id/send_to_docusign', to: 'documents#send_to_docusign'
    resources :folders
    resources :tasks
    resources :categories
    resources :team_members, :only => [:create]
  end

  root to: "app/dashboard#index"

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

end
