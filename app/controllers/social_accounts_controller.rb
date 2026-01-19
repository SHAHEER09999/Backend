class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: %i[ show update destroy ]

  # GET /social_accounts
  def index
    @social_accounts = SocialAccount.all

    render json: @social_accounts
  end

  # GET /social_accounts/1
  def show
    render json: @social_account
  end

  # POST /social_accounts
  def create
    profile = Profile.find(params[:profile_id])

    social_account = profile.social_accounts.build(social_account_params)

    if social_account.save
      render json: social_account, status: :created
    else
      render json: social_account.errors, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /social_accounts/1
  def update
    if @social_account.update(social_account_params)
      render json: @social_account
    else
      render json: @social_account.errors, status: :unprocessable_content
    end
  end

  # DELETE /social_accounts/1
  def destroy
    @social_account.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_social_account
      @social_account = SocialAccount.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def social_account_params
      params.require(:social_account).permit(
        :platform,
        :username,
        :followers
      )
    end
end
