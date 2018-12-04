# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = {}
user['password'] = '12345'
user['password_confirmation'] = '12345'

ActiveRecord::Base.transaction do
  20.times do 
    user['first_name'] = Faker::Name.first_name
    user['last_name'] = Faker::Name.last_name
    user['email'] = Faker::Internet.email
    user['gender'] = ['Male', 'Female', 'Prefer not to say'].sample
    user['tel_no'] = Faker::PhoneNumber.phone_number
    
    User.create(user)
  end
end 

# Seed Events
event = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  40.times do 
    event['name'] = Faker::SwordArtOnline.location
    event['description'] = Faker::StrangerThings.quote
    event['address'] = Faker::Address.street_address
    event['postal_code'] = rand(10000..70000)
    event['state'] = ['Perlis', 'Kedah', 'Kuala Lumpur', 'Perak', 'Kelantan', 'Terengganu', 'Penang', 'Melacca', 'Negeri Sembilan', 'Selangor', 'Johor', 'Pahang', 'Sarawak', 'Sabah'].sample
    event['date'] = Faker::Date.between_except(Date.today, 1.year.from_now, Date.today)
    event['start_hr'] = (0..23).to_a.sample
    event['start_min'] = (0..59).to_a.sample
    event['end_hr'] = (0..23).to_a.sample
    event['end_min'] = (0..59).to_a.sample
    event['max_pax'] = rand(1..5)
    event['price_per_pax'] = rand(30..300)

    event['user_id'] = uids.sample

    Event.create(event)
  end
end