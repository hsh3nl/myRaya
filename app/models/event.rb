class Event < ApplicationRecord
  belongs_to :user

  validates :name, :description, :address, :postal_code, :state, :date, :start_hr, :start_min, :end_hr, :end_min, :max_pax, :price_per_pax, :user_id, presence: true

end
