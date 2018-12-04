class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :no_of_pax, :user_id, :event_id, presence: true
  validates :no_of_pax, numericality: { greater_than_or_equal_to: 1 }
  validate :not_exceed_max_pax

  private

  def not_exceed_max_pax
    total_pax = 0
    event.bookings.each do |b|
      total_pax += b.no_of_pax
    end

    available_pax = event.max_pax - total_pax

    if available_pax == 0
      errors.add(:no_of_pax, "Sorry, the event is fully booked")
    elsif no_of_pax > available_pax
      errors.add(:no_of_pax, "Sorry, the event has only #{available_pax} places left")
    end
  end
end
