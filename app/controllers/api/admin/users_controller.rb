module Api
  module Admin
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :authorize_admin!

      # GET /api/admin/users
      def index
        users = User.where.not(role: "admin")
        render json: users
      end

      # DELETE /api/admin/users/:id
      def destroy
        user = User.find(params[:id])

        if user.role == "admin"
          render json: { error: "Admin users cannot be deleted." }, status: :forbidden
          return
        end

        user.destroy
        render json: { message: "User deleted successfully." }
      end

      private

      def authorize_admin!
        unless current_user.role == "admin"
          render json: { error: "Access denied." }, status: :forbidden
        end
      end
    end
  end
end