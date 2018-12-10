require 'rails_helper'

RSpec.describe Event, type: :model do
	# Validation initiation
	let(:user_attributes)			{ {first_name:'Mr', last_name:'Tester', gender:'Male', tel_no:'018-9999887', email:'test@test.com', password:'12345', password_confirmation:'12345' }}
	let(:proper_price_per_pax)		{ 23 }
	let(:improper_price_per_pax)	{ -50 }
	let(:proper_postal_code)		{ 55550 }
	let(:improper_postal_code)		{ 1234 }
	
	# Active record and custom method initiation
	let(:user)						{ User.create(user_attributes) }
	let(:proper_event_attributes)	{ {name: 'CNY', description: 'welcome', address:'Taman Ma', postal_code:'55530', state:'Kedah',  date:'2018-12-03', start_hr:'12', start_min:'30', end_hr:'15', end_min:'30', max_pax:'5', price_per_pax:'10', user_id:user.id}}
	let(:improper_event_attributes)	{ {name: 'CNY', description: 'welcome', address:'Taman Ma', postal_code:'4567', state:'Kedah',  date:'2018-12-03', start_hr:'12', start_min:'30', end_hr:'15', end_min:'30', max_pax:'2', price_per_pax:'-10'}}	
	let(:event)						{ Event.create(proper_event_attributes) }
	let(:booking)					{ Booking.create(no_of_pax:'1', event_id:event.id, user_id:user.id)}

	context "validation: " do
		[:name, :description, :address, :postal_code, :state, :date, :start_hr, :start_min, :end_hr, :end_min, :max_pax, :price_per_pax, :user_id].each do |field|
			it { should validate_presence_of(field) }
		end
		it { is_expected.to allow_value(proper_price_per_pax).for(:price_per_pax) }
		it { is_expected.not_to allow_value(improper_price_per_pax).for(:price_per_pax)  }
		it { is_expected.to allow_value(proper_postal_code).for(:postal_code) }
		it { is_expected.not_to allow_value(improper_postal_code).for(:postal_code)  }
	end

	# Active Record default method tests
	context "creates: " do
		it "takes in valid attributes for Events" do
			expect{ Event.create(proper_event_attributes) }.not_to raise_error
		end

		it "won't create an entry if invalid event attributes is being supplied" do
			Event.create(improper_event_attributes)
			expect( Event.find_by(improper_event_attributes) ).to be nil
		end

		it "creates an entry when proper attributes for Event are being supplied" do
			Event.create(proper_event_attributes)
			expect( Event.find_by(proper_event_attributes) ).not_to be nil
		end
	end

	# Custom defined method tests
	context "Object method - places_left:" do
		it "when an event has total 5 places, and 1 place booked should return 4" do
			user
			event
			booking
			expect( event.places_left ).to eq 4
		end

		it "when an event has total 5 places, and 1 place booked should not return 3" do
			user
			event
			booking
			expect( event.places_left ).not_to eq 3
		end
	end

end
