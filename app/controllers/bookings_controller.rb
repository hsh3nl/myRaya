class BookingsController < ApplicationController
    before_action :check_user_signin
    
    def show
        @event = Event.find_by(id: params[:event_id])
        @booking = Booking.find_by(id: params[:id])
        @user = @booking.user
    end
    
    def new
        @event = Event.find_by(id: params[:event_id])
        @booking = Booking.new
        @client_token = Braintree::ClientToken.generate
    end

    def create
        booking = Booking.new(
            no_of_pax: booking_params[:no_of_pax],
            spec_req: booking_params[:spec_req],
            user_id: current_user.id,
            event_id: booking_params[:event_id]
        )

        if booking.save
            redirect_to event_booking_path(booking.event, booking)
        else
            flash[:notice] = booking.errors.messages[:no_of_pax]
            redirect_to new_event_booking_path(booking.event_id)
        end
    end

    private

    def booking_params
        params.require(:booking).permit(:no_of_pax, :spec_req, :event_id)
    end
end
