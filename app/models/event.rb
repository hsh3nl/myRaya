class Event < ApplicationRecord
  belongs_to :user
  has_many :bookings

  include PgSearch
  pg_search_scope :search_by_name_state, :against => [:name, :state]

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

  # Custom method to return whether the event is within given argument as days
  def within_days(days)
    days_from_now = Time.now + 60*60*24*days
    event_date = Time.parse(date.to_s + ' ' + start_hr + ":" + start_min)
    if event_date < days_from_now
      return true
    else
      return false
    end
  end

  # Custom method to return the multiple of hours in blocks of (argument) from today
  # ie: event is in 3 days 1 hour, means 73hours. given hour_multiple of 3
  # the result is then 24
  def nearest_hr_count_with_multiple(hour_multiple)
    # Determine the event date
    event_date = Time.parse(date.to_s + ' ' + start_hr + ":" + start_min)

    # find the multiple of the event from today, usually results in a float
    multiple = (event_date - Time.now)/60/60/hour_multiple

    # round down to the nearest multiple
    # the reason for this is so that the weather is taken before event
    lower_multiple = multiple.floor
  end
end
