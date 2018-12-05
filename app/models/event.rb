class Event < ApplicationRecord
  belongs_to :user
  has_many :bookings

  mount_uploaders :attachments, EventUploader

  validates :name, :description, :address, :postal_code, :state, :date, :start_hr, :start_min, :end_hr, :end_min, :max_pax, :price_per_pax, :user_id, presence: true
  validates :max_pax, :price_per_pax, numericality: { greater_than_or_equal_to: 1 }
  validates :postal_code, format: { with: /\d{5}/, message: "Postal code must be a 5 digit number" }

  # This method returns the number of places left for a certain event
  def places_left
    if bookings.count > 0
      total_pax = 0
      bookings.each do |b|
        total_pax += b.no_of_pax
      end
      return max_pax - total_pax
    else
      max_pax
    end
  end

end
