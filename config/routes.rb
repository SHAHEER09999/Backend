Rails.application.routes.draw do
  get "public_influencers/index"
  get "public_influencers/filters"
  namespace :api do
    namespace :admin do
      resources :users, only: [:index, :destroy]
    end
  end
  resources :admin_user_managements
  resources :public_influencers, only: [:index] do
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

  # 👇 ADD THESE ROUTES HERE (IMPORTANT)
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
  end
  resources :campaigns, only: [:index, :show, :update, :destroy] do
    resources :campaign_applications, only: [:create, :destroy]
  end
  resources :meetings, only: [:index, :create, :destroy] do
    post :respond, to: 'meeting_responses#respond'
  end
  post "/social_accounts/verify_and_create", to: "social_accounts#verify_and_create"
  get "/categories/options", to: "categories#options"

end