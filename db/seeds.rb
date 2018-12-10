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
    user['image'] = [Rails.root.join("app/assets/images/seeds/seed1.png").open, Rails.root.join("app/assets/images/seeds/seed2.png").open, Rails.root.join("app/assets/images/seeds/seed3.png").open, ''].sample
    
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
    event['state'] = ['Kuala Lumpur', 'Labuan', 'Johor', 'Kedah', 'Kelantan', 'Melaka', 'Negeri Sembilan', 'Pahang', 'Pulau Pinang', 'Perak', 'Perlis', 'Sabah', 'Sarawak', 'Selangor', 'Terengganu'].sample
    event['date'] = Faker::Date.between_except(Date.today, 1.year.from_now, Date.today)
    event['start_hr'] = ('00'..'23').to_a.sample
    event['start_min'] = ('00'..'59').to_a.sample
    event['end_hr'] = ('00'..'23').to_a.sample
    event['end_min'] = ('00'..'59').to_a.sample
    event['max_pax'] = rand(1..20)
    event['price_per_pax'] = rand(10..300)
    event['attachments'] = [[Rails.root.join("app/assets/images/seeds/cny1.jpg").open,Rails.root.join("app/assets/images/seeds/cny2.png").open],[Rails.root.join("app/assets/images/seeds/dee1.jpg").open,Rails.root.join("app/assets/images/seeds/dee2.jpeg").open],[Rails.root.join("app/assets/images/seeds/raya1.png").open,Rails.root.join("app/assets/images/seeds/raya2.png").open]].sample

    event['user_id'] = uids.sample

    Event.create(event)
  end
end