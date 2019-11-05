require 'rails_helper'

RSpec.describe 'User addresses show page' do
  describe 'As a user, when I visit my profile page and click my addresses' do
    before(:each) do
      @user = User.create(name: 'Ryan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'ryan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = Address.create(nickname: 'Home', name: 'Ryan Hantak', street_address: '123 A Street', city: 'Dallas', state: 'TX', zip: '75070', user_id: @user.id)
      @address_2 = Address.create(nickname: 'Work', name: 'Ryan Hantak', street_address: '234 B Street', city: 'Denver', state: 'CO', zip: '80202', user_id: @user.id)

      visit '/profile'
      click_link 'My Addresses'
    end

    it "Each address nickname is a link to that address' show page" do
      within "#address-#{@address_1.id}" do
        expect(page).to have_link "#{@address_1.nickname}"

        click_link "#{@address_1.nickname}"
      end
      expect(current_path).to eq("/profile/addresses/#{@address_1.id}")
    end

    it "On the show page, I see only the information for that address" do
      within "#address-#{@address_1.id}" do
        click_link "#{@address_1.nickname}"
      end

      expect(page).to have_content(@address_1.nickname)
      expect(page).to have_content(@address_1.name)
      expect(page).to have_content(@address_1.street_address)
      expect(page).to have_content(@address_1.city)
      expect(page).to have_content(@address_1.state)
      expect(page).to have_content(@address_1.zip)

      expect(page).to_not have_content(@address_2.nickname)
      expect(page).to_not have_content(@address_2.street_address)
      expect(page).to_not have_content(@address_2.city)
      expect(page).to_not have_content(@address_2.state)
      expect(page).to_not have_content(@address_2.zip)
    end
  end
end
