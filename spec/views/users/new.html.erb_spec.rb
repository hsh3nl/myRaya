require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do
    it "displays the sign up page" do 
        render
        ['First Name', 'Last Name', 'Gender', 'Email'].each do |field|
            expect(rendered).to match(field)
		    end
    end
end

RSpec.feature "User Features", type: :feature do
    context 'create new user' do 
      before(:each) do
        visit '/sign_up'
        within("form") do
          fill_in :user_first_name, with: 'john'
          fill_in :user_last_name, with: 'doe'
          fill_in :user_tel_no, with: '018-8800876'
          select "Male", :from => :user_gender
          attach_file(:user_image, Rails.root.join("app/assets/images/seeds/seed1.png")) 
          fill_in :user_email, with: 'test@test.com'
          fill_in :user_password,	with: "abc123" 
        end
      end
  
      scenario "should be successful" do
        within("form") do
          fill_in :user_password_confirmation, with: 'abc123'
        end
        click_button 'Complete Registration'
        expect(page).to have_content 'Registration complete! Please sign in.'
      end

      scenario "should fail" do
        click_button 'Complete Registration'
        expect(page).to have_content 'Password confirmation doesn\'t match Password'
      end
    end
end

# RSpec.feature "Url features", type: :feature, js: true do
#     context 'create new short url' do 
#         before(:each) do 
#             visit root_path

#             click_link('new_url')
#         end

#         scenario 'should be successful' do
#             within('form') do
#                 fill_in 'long_url', with: 'www.google.com'
#             end

#             click_button('Submit!')
#             expect(page).to have_content('www.google.com')
#         end

#         scenario 'should fail' do
#             within('form') do
#                 fill_in 'long_url', with: 'wwwadfafsa'
#             end
            
#             click_button('Submit!')
#             expect(page).to have_content(': Please enter a proper url')
#         end

#         scenario 'should show up at the index page' do
#             within('form') do
#                 fill_in 'long_url', with: 'www.freeme.co.uk'
#             end
#             click_button('Submit!')
            
#             new_url = Url.last
#             expect(page).to have_content(new_url.long_url)
#             expect(page).to have_content(new_url.short_url)
#         end
#     end

#     context 'create a list of short urls' do 
#         scenario 'should show a list of the long and corresponding urls' do
#             visit root_path

#             click_link('new_url')
            
#             within('form') do
#                 fill_in 'long_url', with: 'www.google.com'
#             end

#             click_button('Submit!')

#             click_link('new_url')
            
#             within('form') do
#                 fill_in 'long_url', with: 'www.fiseher.com'
#             end

#             click_button('Submit!')

#             new_url_1 = Url.all[0]
#             new_url_2 = Url.all[1]
#             expect(page).to have_content(new_url_1.long_url)
#             expect(page).to have_content(new_url_1.short_url)
#             expect(page).to have_content(new_url_2.long_url)
#             expect(page).to have_content(new_url_2.short_url)
#         end 
#     end
# end


