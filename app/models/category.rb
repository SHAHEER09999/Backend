class Category < ApplicationRecord
  belongs_to :profile
  enum :categories, [
    :fashion,
    :beauty,
    :lifestyle,
    :travel,
    :food,
    :fitness,
    :health,
    :tech,
    :gaming,
    :photography,
    :parenting,
    :education,
    :finance,
    :music,
    :pets,
    :art,
    :design,
    :sports,
    :movies,
    :books,
    :home_decor,
    :luxury,
    :marketing,
    :nature,
    :comedy
  ]
end
