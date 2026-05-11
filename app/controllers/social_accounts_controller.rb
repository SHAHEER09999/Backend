class SocialAccountsController < ApplicationController
  before_action :set_social_account, only: %i[ show update destroy ]
  before_action :authenticate_user!
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
  def verify_and_create
    return render json: { error: "Only influencers can add social accounts" }, status: :forbidden unless current_user.influencer?

    profile = current_user.profile
    return render json: { error: "Profile not found" }, status: :not_found unless profile

    platform = params[:platform]
    username = params[:username]

    unless platform == "youtube"
      return render json: { error: "Only YouTube is supported currently" }, status: :unprocessable_entity
    end

    result = YoutubeService.verify(username)

    unless result[:success]
      return render json: { error: result[:error] }, status: :unprocessable_entity
    end

    social_account = profile.social_accounts.find_or_initialize_by(platform: :youtube)

    social_account.username = result[:username]
    social_account.followers = result[:followers]

    social_account.save!

    render json: {
      message: "YouTube account verified successfully",
      social_account: {
        id: social_account.id,
          platform: social_account.platform,
          username: social_account.username,
          followers: social_account.followers,
          title: result[:title]
        }
      }, status: :ok
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
