class UserMailer < ApplicationMailer
  def delete_account_email(user)
    @user = user
    @url = "http://localhost:3000/users/delete_account?token=#{user.delete_token}"

    mail(to: @user.email, subject: "Confirm Account Deletion")
  end
end