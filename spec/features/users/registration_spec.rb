require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)
    end

    it 'I can register as a user and my address is saved' do
      visit registration_path

      fill_in 'Name', with: 'Megan'
      fill_in 'Email', with: 'megan@example.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      fill_in :user_address_nickname, with: 'My Home'
      fill_in :user_address_name, with: 'Megan'
      fill_in :user_address_street_address, with: '123 A Street'
      fill_in :user_address_city, with: 'Denver'
      fill_in :user_address_state, with: 'CO'
      fill_in :user_address_zip, with: '80202'
      click_button 'Register'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')

      click_link 'My Addresses'

        expect(page).to have_content("My Home")
        expect(page).to have_content("Megan")
        expect(page).to have_content("123 A Street")
        expect(page).to have_content('Denver')
        expect(page).to have_content('CO')
        expect(page).to have_content('80202')

    end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in 'Name', with: 'Megan'
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("email: [\"can't be blank\"]")
        expect(page).to have_content("password: [\"can't be blank\"]")
      end

      it 'I use a non-unique email' do
        user = User.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')

        visit registration_path

        fill_in 'Name', with: user.name
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("email: [\"has already been taken\"]")
      end
    end
  end
end
