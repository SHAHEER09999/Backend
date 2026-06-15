class PublicInfluencersController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def index
    profiles = Profile
      .includes(:social_accounts, :categories)
      .joins(:user)
      .where(users: { role: User.roles[:influencer] })

    # CATEGORY FILTER
    if params[:category].present?
      profiles = profiles.joins(:categories)
                         .where(categories: { categories: params[:category] })
    end

    # GENDER FILTER
    if params[:gender].present?
      profiles = profiles.where(gender: Profile.genders[params[:gender]])
    end

    # LANGUAGE FILTER
    if params[:language].present?
      profiles = profiles.where(language: params[:language])
    end

    # LOCATION FILTER
    if params[:location].present?
      profiles = profiles.where(location_website: params[:location])
    end

    # AGE FILTER
    if params[:min_age].present?
      profiles = profiles.where("age >= ?", params[:min_age])
    end

    if params[:max_age].present?
      profiles = profiles.where("age <= ?", params[:max_age])
    end

    # DELIVERY TIME
    if params[:delivery_time].present?
      profiles = profiles.where(delivery_time: params[:delivery_time])
    end

    # PRICE FILTER
    if params[:min_price].present?
      profiles = profiles.joins(:social_accounts)
                         .where("social_accounts.price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      profiles = profiles.joins(:social_accounts)
                         .where("social_accounts.price <= ?", params[:max_price])
    end

    distinct_profile_ids = profiles.select(:id).distinct

    # 2. Re-query those specific IDs and apply the random sorting, 
    # making sure to re-apply the includes to prevent N+1 queries during rendering
    profiles = Profile.includes(:social_accounts, :categories)
                      .where(id: distinct_profile_ids)
                      .order("RANDOM()")
    render json: profiles.map { |profile|
      {
        id: profile.id,
        name: profile.name,
        image_url: profile.image.attached? ? url_for(profile.image) : nil,
        age: profile.age,
        description: profile.description, # <--- ADD THIS LINE
        gender: profile.gender,
        language: profile.language,
        location: profile.location_website,
        delivery_time: profile.delivery_time,
        social_accounts: profile.social_accounts,
        categories: profile.categories
      }
    }
  end

  def show
    profile = Profile.find(params[:id])

    # 1. Fetch the last 5 feedbacks
    feedbacks = profile.received_feedbacks
                      .includes(:brand_profile)
                      .order(created_at: :desc)
                      .limit(5)

    # 2. Render JSON including the reviews exactly like we did in ProfilesController
    render json: profile.as_json(
      include: [:social_accounts, :categories]
    ).merge(
      image_url: profile.image.attached? ? url_for(profile.image) : nil,
      
      average_rating: profile.average_rating,
      total_feedbacks: profile.total_feedbacks,

      # ✅ THIS SENDS THE REVIEWS TO THE FRONTEND
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
  def filters
    render json: {
      categories: Category.distinct.pluck(:categories),

      locations: Profile
        .where.not(location_website: [nil, ""])
        .distinct
        .pluck(:location_website),

      languages: Profile
        .where.not(language: [nil, ""])
        .distinct
        .pluck(:language),

      genders: Profile.genders.keys,

      delivery_times: Profile
        .where.not(delivery_time: [nil, ""])
        .distinct
        .pluck(:delivery_time)
    }
  end
end