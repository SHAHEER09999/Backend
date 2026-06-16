class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ destroy ]
  before_action :authenticate_user!

  # GET /profiles
  def index
    @profiles = Profile.all
    render json: @profiles
  end

  # GET /profile or /profiles/:id
  def show
    profile = params[:id].present? ? Profile.find(params[:id]) : current_user.profile

    if profile.nil?
      return render json: { error: "Profile not found" }, status: :not_found
    end

    feedbacks = profile.received_feedbacks
                      .includes(:brand_profile)
                      .order(created_at: :desc)
                      .limit(5)

    render json: profile.as_json(
      include: [:social_accounts, :categories]
    ).merge(
      role: profile.user.role, # 👈 Added: Sends the user enum role to frontend
      image_url: profile.image.attached? ? url_for(profile.image) : nil,
      average_rating: profile.average_rating,
      total_feedbacks: profile.total_feedbacks,
      reviews: feedbacks.map do |f|
        {
          id: f.id,
          user_name: f.brand_profile&.name || "Unknown User",
          comment: f.comment,
          created_at: f.created_at
        }
      end
    )
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params.merge(user_id: current_user.id))

    if @profile.save
      render json: profile_response(@profile), status: :created, location: @profile
    else
      render json: @profile.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /profile
  def update
    @profile = current_user.profile

    if @profile.update(profile_params)
      # Update categories (replace old ones)
      if params[:categories].present?
        @profile.categories.destroy_all

        params[:categories].values.each do |cat|
          next unless Category.categories.keys.include?(cat)

          @profile.categories.create!(categories: cat)
        end
      end

      render json: profile_response(@profile)
    else
      render json: @profile.errors, status: :unprocessable_content
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile = current_user.profile
    @profile.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.expect(profile: [ :name, :image, :description, :location_website, :language, :gender, :age, :delivery_time ])
  end

  def profile_response(profile)
    profile.as_json(include: :categories).merge(
      role: profile.user.role, # 👈 Added: Ensures role stays synced when saving changes
      image_url: profile.image.attached? ? url_for(profile.image) : nil,
      average_rating: profile.average_rating,
      total_feedbacks: profile.total_feedbacks
    )
  end
end