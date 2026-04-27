class Users::DeletionsController < ApplicationController
  before_action :authenticate_user!, only: [:request_delete]

  # Step 1: send email
  def request_delete
    current_user.generate_delete_token
    UserMailer.delete_account_email(current_user).deliver_later

    render json: { message: "Confirmation email sent" }, status: :ok
  end

  # Step 2: confirm deletion via email
  def confirm_delete
    user = User.find_by(delete_token: params[:token])

    if user&.delete_token_valid?(params[:token])
      user.destroy

      redirect_to "http://localhost:5173/account-deleted"
    else
      redirect_to "http://localhost:5173/delete-error"
    end
  end
end