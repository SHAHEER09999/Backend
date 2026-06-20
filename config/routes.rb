Rails.application.routes.draw do

  namespace :api do
    namespace :admin do
      resources :users, only: [:index, :destroy]
        resources :reports, only: [:index, :show]
    end
  end
  
  resources :admin_user_managements
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:index, :create]
  end
  
  # ✅ THIS BLOCK HANDLES EVERYTHING PERFECTLY:
  resources :public_influencers, only: [:index, :show] do
    collection do
      get :filters
    end
  end
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }

  post "users/request_delete", to: "users/deletions#request_delete"
  get "users/delete_account", to: "users/deletions#confirm_delete"
  get "/profile", to: "profiles#show"
  put "/profile", to: "profiles#update"

  resources :profiles do
    resources :social_accounts
    resources :categories
    resources :bank_accounts
    resources :campaigns
    resources :meetings
    resources :feedbacks, only: [:index, :create]
    resources :reports, only: [:create]

  end
  
  resources :campaigns, only: [:index, :show, :update, :destroy] do
    resources :campaign_applications, only: [:create, :destroy]
  end
  
  resources :meetings, only: [:index, :create, :destroy] do
    collection do
      get :chat_brands
      post :create_chat_meeting
    end
    post :respond, to: 'meeting_responses#respond'
  end
  
  post "/social_accounts/verify_and_create", to: "social_accounts#verify_and_create"
  get "/categories/options", to: "categories#options"
end