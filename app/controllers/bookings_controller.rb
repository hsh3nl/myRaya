class BookingsController < ApplicationController
    before_action :check_user_signin
    
    def show
        @event = Event.find_by(id: params[:event_id])
        @booking = Booking.find_by(id: params[:id])
        @user = @booking.user
        @paid = sprintf('%.2f', @booking.paid)

        if @event.within_days(5)
            hour_count = @event.nearest_hr_count_with_multiple(3) + 1
            response = HTTP.get("http://api.openweathermap.org/data/2.5/forecast?q=#{@event.state},my&appid=#{ENV['OPENWEATHER_KEY']}&cnt=#{hour_count}&units=metric")
            weather_hash = JSON.parse(response)
            required_weather = weather_hash['list'].last['weather'][0]

            icon_link = "http://openweathermap.org/img/w/#{required_weather['icon']}.png"
            @weather_data = {title:required_weather['main'], status:required_weather['description'].titleize, icon_tag:icon_link, error: 0}
        else
            @weather_data = {title:'No Weather Data', status:'Available 5 days from event', error: 1}
        end
    end
    
    def new
        @event = Event.find_by(id: params[:event_id])
        @booking = {no_of_pax: params[:no_of_pax]}
        @price = sprintf('%.2f', params[:no_of_pax].to_i * @event.price_per_pax)
        @client_token = Braintree::ClientToken.generate
        promo = 5
        @discount = sprintf('%.2f', promo)
        @discounted_price = sprintf('%.2f', params[:no_of_pax].to_i * @event.price_per_pax - @promo)
    end

    def create
        event = Event.find_by(id: checkout_params[:event_id])
        discount = 5
        checkout_price = checkout_params[:no_of_pax].to_i * event.price_per_pax - discount
        booking = Booking.new(
            no_of_pax: checkout_params[:no_of_pax],
            spec_req: checkout_params[:spec_req],
            user_id: current_user.id,
            event_id: event.id,
            paid: checkout_price,
            discount: discount
            )
        
        if booking.valid?
            # Payment initialisation
            nonce_from_the_client = checkout_params[:payment_method_nonce]
        
            result = Braintree::Transaction.sale(
            :amount => checkout_price,
            :payment_method_nonce => nonce_from_the_client,
            :options => {
                :submit_for_settlement => true
            })
        
            if result.success?
                booking.save
                flash[:success] = ['Transation Successful! Your booking was reserved :)']
                redirect_to event_booking_path(event, booking) 
            else
                flash[:notice] = ['Something went wrong. No transaction occurred.']
                redirect_to event_path(event)
            end
        else
            flash[:notice] = booking.errors.messages[:no_of_pax]
            redirect_to event_path(event)
        end
    end

    private

    def booking_params
        params.require(:booking).permit(:no_of_pax, :spec_req, :event_id)
    end

    def checkout_params
        params.require(:checkout_form).permit(:payment_method_nonce, :spec_req, :no_of_pax, :event_id)
    end
end
