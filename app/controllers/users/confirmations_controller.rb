class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  def show
    user = User.confirm_by_token(params[:confirmation_token])

    if user.errors.empty?
      render json: { message: "Email confirmed successfully" }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end