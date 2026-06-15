module Api
  module Admin
    class ReportsController < ApplicationController
      before_action :authenticate_user!
      before_action :ensure_admin

      def index
        reports = Report.includes(
          reporter_profile: :user, 
          reported_profile: :user, 
          proof_images_attachments: :blob
        ).order(created_at: :desc)

        render json: reports.map { |r|
          {
            id: r.id,
            description: r.description,
            created_at: r.created_at,

            reporter_email: r.reporter_profile&.user&.email,
            reporter_name: r.reporter_profile&.name,

            # Fetching the email from the associated User record
            reported_influencer: r.reported_profile&.user&.email,

            images: r.proof_images.map { |img|
              rails_blob_url(img, host: request.base_url)
            }
          }
        }
      end

      def show
        r = Report.find(params[:id])

        render json: {
          id: r.id,
          description: r.description,
          reporter_email: r.reporter_profile&.user&.email,
          reporter_name: r.reporter_profile&.name,
          
          # Fetching the email from the associated User record
          reported_influencer: r.reported_profile&.user&.email,
          
          images: r.proof_images.map { |img| 
            rails_blob_url(img, host: request.base_url) 
          }
        }
      end

      private

      def ensure_admin
        unless current_user.admin?
          render json: { error: "Access denied" }, status: :forbidden
        end
      end
    end
  end
end