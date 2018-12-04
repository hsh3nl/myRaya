class Event < ApplicationRecord
  belongs_to :user
  has_many :bookings

  validates :name, :description, :address, :postal_code, :state, :date, :start_hr, :start_min, :end_hr, :end_min, :max_pax, :price_per_pax, :user_id, presence: true
  validates :max_pax, :price_per_pax, numericality: { greater_than_or_equal_to: 1 }
  validates :postal_code, format: { with: /\d{5}/, message: "Postal code must be a 5 digit number" }

end
