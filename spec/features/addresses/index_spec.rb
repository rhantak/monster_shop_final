require 'rails_helper'

RSpec.describe 'User addresses index page' do
  describe 'As a user, when I visit my profile page' do
    before(:each) do
      @user = User.create(name: 'Ryan', email: 'ryan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = Address.create(nickname: 'Home', name: 'Ryan Hantak', street_address: '123 A Street', city: 'Dallas', state: 'TX', zip: '75070', user_id: @user.id)
      @address_2 = Address.create(nickname: 'Work', name: 'Ryan Hantak', street_address: '234 B Street', city: 'Denver', state: 'CO', zip: '80202', user_id: @user.id)

      visit '/profile'

    end

    it "I see a link to my addresses" do
      expect(page).to have_link 'My Addresses'

      click_link 'My Addresses'
      expect(current_path).to eq('/profile/addresses')
    end

    it "When I go to my addresses page, I see all my addresses" do
      click_link 'My Addresses'

      within "#address-#{@address_1.id}" do
        expect(page).to have_content(@address_1.nickname)
        expect(page).to have_content(@address_1.name)
        expect(page).to have_content(@address_1.street_address)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(@address_2.nickname)
        expect(page).to have_content(@address_2.name)
        expect(page).to have_content(@address_2.street_address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
      end
    end
  end
end
