class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    user = User.confirm_by_token(params[:confirmation_token])

    if user.errors.empty?
      redirect_to "http://localhost:5173/email-confirmed?verified=true"
    else
      redirect_to "http://localhost:5173/email-confirmed?verified=false"
    end
  end
end