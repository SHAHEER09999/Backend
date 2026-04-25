class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # 📧 Send reset email
  def create
    user = User.find_by(email: params[:user][:email])

    if user
      user.send_reset_password_instructions
      render json: { message: "Reset email sent" }, status: :ok
    else
      render json: { error: "Email not found" }, status: :not_found
    end
  end
  def edit
    redirect_to "http://localhost:5173/reset-password?token=#{params[:reset_password_token]}"
  end

  # 🔐 Reset password
  def update
    user = User.reset_password_by_token(reset_password_params)

    if user.errors.empty?
      render json: { message: "Password updated successfully" }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def reset_password_params
    params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
  end
end