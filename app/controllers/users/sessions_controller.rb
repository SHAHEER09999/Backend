# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if !resource.confirmed?
      render json: {
        error: "Please confirm your email first."
      }, status: :unauthorized
    else
      render json: {
        message: 'Logged in successfully.',
        data: {
          id: resource.id,
          email: resource.email,
          role: resource.role
        }
      }, status: :ok
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session."    
      }, status: :unauthorized
    end
  end
end
