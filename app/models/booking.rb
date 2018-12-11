class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :no_of_pax, :user_id, :event_id, :paid, :discount, presence: true
  validates :no_of_pax, numericality: { greater_than_or_equal_to: 1 }
  validates :paid, :discount, numericality: { greater_than_or_equal_to: 0 }
  validate :not_exceed_max_pax

  def self.analytics(period_in_days)
    new_bookings_since = 0
    cashflow = 0
    last_new_booking = Booking.last.created_at if Booking.last
 
    Booking.all.each do |b|
        if b.created_at > Date.today - period_in_days.day
            new_bookings_since += 1
            cashflow += b.paid
        end
    end

    bookings = {
        count_all: Booking.count,
        last_new: last_new_booking,
        count_since: new_bookings_since,
    }

    return {bookings: bookings, cashflow: sprintf('%.2f',cashflow)}
  end


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
      errors.add(:no_of_pax, "Sorry, the event has #{available_pax} place(s) left")
    end
  end
end
