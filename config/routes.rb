Rails.application.routes.draw do

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
  end
  post "/social_accounts/verify_and_create", to: "social_accounts#verify_and_create"
  get "/categories/options", to: "categories#options"

end