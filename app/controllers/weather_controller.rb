class WeatherController < ApplicationController
    def identify
        event_id = weather_params[:event].match(/\d+/)[0]
        event = Event.find(event_id)
        
        if event.within_days(5)
            hour_count = event.nearest_hr_count_with_multiple(3) + 1
            response = HTTP.get("http://api.openweathermap.org/data/2.5/forecast?q=#{event.state},my&appid=#{ENV['OPENWEATHER_KEY']}&cnt=#{hour_count}&units=metric")
            weather_hash = JSON.parse(response)
            required_weather = weather_hash['list'].last['weather'][0]

            icon_link = "<img src='http://openweathermap.org/img/w/#{required_weather['icon']}.png'>"
            weather_data = {title:required_weather['main'], status:required_weather['description'].titleize, icon_tag:icon_link, error: 0}
        else
            weather_data = {title:'No Weather Data', status:'Available 5 days from event', error: 1}
        end

        respond_to do |f|
            f.json {render :json => weather_data}
        end
    end

    private

    def weather_params
        params.permit(:event)   
    end
end
