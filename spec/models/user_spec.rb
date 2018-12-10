require 'rails_helper'

RSpec.describe User, type: :model do
	# Validation initiation
	let(:proper_user_attr)			{ {first_name:'Mr', last_name:'Tester', gender:'Male', tel_no:'018-9999887', email:'test@test.com', password:'12345', password_confirmation:'12345', image:Rails.root.join("app/assets/images/seeds/seed1.png").open }}
	let(:improper_user_attr)		{ {first_name:'', last_name:'Tester', gender:'Male', tel_no:'018-9999887', email:'test@test.com', password:'12345', password_confirmation:'1245' } }
	let(:proper_image_file)			{ Rails.root.join("app/assets/images/seeds/seed1.png").open }
	let(:proper_email) 				{ 'test@test.com' }
	let(:improper_email)			{ 'test.test.com' }

	
	# Active record and custom method initiation
	let(:user)						{ User.create(proper_user_attr) }
	let(:proper_event_attributes)	{ {name: 'CNY', description: 'welcome', address:'Taman Ma', postal_code:'55530', state:'Kedah',  date:'2018-12-03', start_hr:'12', start_min:'30', end_hr:'15', end_min:'30', max_pax:'5', price_per_pax:'10', user_id:user.id}}
	let(:event)						{ Event.create(proper_event_attributes) }
	let(:booking)					{ Booking.create(no_of_pax:'1', event_id:event.id, user_id:user.id)}



	context "validation: " do
		[:first_name, :last_name, :gender, :tel_no].each do |field|
			it { should validate_presence_of(field) }
		end
		it { is_expected.to allow_value(proper_email).for(:email) }
		it { is_expected.not_to allow_value(improper_email).for(:email)  }
		it { is_expected.to allow_value(proper_image_file).for(:image) }
	end

	# Active Record default method tests
	context "creates: " do
		it "takes in valid attributes for User" do
			expect{ User.create(proper_user_attr) }.not_to raise_error
		end

		it "won't create an entry if invalid event attributes is being supplied" do
			User.create(improper_user_attr)
			expect( User.find_by({first_name:'', last_name:'Tester', gender:'Male', tel_no:'018-9999887', email:'test@test.com'}) ).to be nil
		end

		it "creates an entry when proper attributes for Event are being supplied" do
			User.create(proper_user_attr)
			expect( User.find_by({first_name:'Mr', last_name:'Tester', gender:'Male', tel_no:'018-9999887', email:'test@test.com' }) ).not_to be nil
		end
	end

	# Active Record enumerator functionality
	context "role assignment: " do
		it "is assigned as customer on default" do
			expect( User.create(proper_user_attr).customer? ).to eq true
		end

		it "is assigned as master, should return as master" do
			user = User.create(proper_user_attr)
			user.master!
			expect( user.role ).to eq 'master'
		end

		it "is assigned as moderator, should not return as customer" do
			user = User.create(proper_user_attr)
			user.moderator!
			expect( user.role ).not_to eq 'customer'
		end
	end

	# Active Record association test
	context " association test for user has many events" do
		it " should return event object when one event is created for it" do
			user
			event
			expect( user.events.count ).to eq 1
		end

		it " should not return two event objects when one event is created for it" do
			user
			event
			expect( user.events.count ).not_to eq 2
		end
	end

	context " association test for user has many bookigss" do
		it " should return a booking object when one event is created for it" do
			user
			event
			booking
			expect( user.bookings.count ).to eq 1
		end

		it " should not return two booking objects when one event is created for it" do
			user
			event
			booking
			expect( user.bookings.count ).not_to eq 2
		end
	end

end
