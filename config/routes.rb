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

  resources :profiles do
    resources :social_accounts
    resources :categories
  end

end