class EventsController < ApplicationController
    def index
        if params[:find]
            @events = Event.search_by_name_state(params[:find]).page(params[:page]).per(8).order('date ASC')
        else
            @events = Event.all.page(params[:page]).per(8).order('date ASC')
        end
    end

    def show
        @event = Event.find_by(id:params[:id])
        @booking = Booking.new

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
        @event = Event.new
    end

    def create
        event = Event.new(
            name: event_params[:name],
            description: event_params[:description],
            address: event_params[:address],
            postal_code: event_params[:postal_code],
            state: event_params[:state],
            date: event_params[:date],
            start_hr: event_params[:start_hr],
            start_min: event_params[:start_min],
            end_hr: event_params[:end_hr],
            end_min: event_params[:end_min],
            max_pax: event_params[:max_pax],
            price_per_pax: event_params[:price_per_pax],
            attachments: event_params[:attachments],
            user_id: current_user.id
            ) 
        if event.save
            redirect_to event_path(event)
        else
            flash[:notice] = event.errors.full_messages
            redirect_to new_event_path
        end
    end

    def edit
        @event = Event.find_by(id: params[:id])
        check_user_event(@event)
    end

    def update
        event = Event.find_by(id: params[:id])
        check_user_event(event)

        if event.update(name: event_params[:name], description: event_params[:description], address: event_params[:address], postal_code: event_params[:postal_code], state: event_params[:state], date: event_params[:date], start_hr: event_params[:start_hr], start_min: event_params[:start_min], end_hr: event_params[:end_hr], end_min: event_params[:end_min], max_pax: event_params[:max_pax], price_per_pax: event_params[:price_per_pax],attachments: event_params[:attachments])
            redirect_to event
        else 
            flash[:notice] = event.errors.full_messages
            redirect_to edit_event_path(event)
        end
    end

    def destroy
        event = Event.find_by(id: params[:id])
        check_user_event(event)

        if event.destroy
            flash[:success] = ["The event #{event.name} has been removed."]
            redirect_to dashboard_path(current_user)
        else
            flash[:notice] = ["Something went wrong"]
            redirect_back(fallback_location: dashboard_path(current_user))
        end
    end

    private

    def event_params
        params.require(:event).permit(:name, :description, :address, :postal_code, :state, :date, :start_hr, :start_min, :end_hr, :end_min, :max_pax, :price_per_pax, attachments: [])
    end
end
