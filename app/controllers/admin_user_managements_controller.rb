class AdminUserManagementsController < ApplicationController
  before_action :set_admin_user_management, only: %i[ show update destroy ]

  # GET /admin_user_managements
  def index
    @admin_user_managements = AdminUserManagement.all

    render json: @admin_user_managements
  end

  # GET /admin_user_managements/1
  def show
    render json: @admin_user_management
  end

  # POST /admin_user_managements
  def create
    @admin_user_management = AdminUserManagement.new(admin_user_management_params)

    if @admin_user_management.save
      render json: @admin_user_management, status: :created, location: @admin_user_management
    else
      render json: @admin_user_management.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /admin_user_managements/1
  def update
    if @admin_user_management.update(admin_user_management_params)
      render json: @admin_user_management
    else
      render json: @admin_user_management.errors, status: :unprocessable_content
    end
  end

  # DELETE /admin_user_managements/1
  def destroy
    @admin_user_management.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_user_management
      @admin_user_management = AdminUserManagement.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def admin_user_management_params
      params.expect(admin_user_management: [ :user_id ])
    end
end
