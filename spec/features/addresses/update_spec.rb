require 'rails_helper'

RSpec.describe 'User addresses can be updated' do
  describe 'As a user, when I visit an address show page' do
    before(:each) do
      @user = User.create(name: 'Ryan', email: 'ryan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = Address.create(nickname: 'Home', name: 'Ryan Hantak', street_address: '123 A Street', city: 'Dallas', state: 'TX', zip: '75070', user_id: @user.id)

      visit '/profile'
      click_link 'My Addresses'
      within "#address-#{@address_1.id}" do
        click_link "#{@address_1.nickname}"
      end
    end

    it "I see a link to edit the address" do
      click_link 'Edit Address'
      expect(current_path).to eq("/profile/addresses/#{@address_1.id}/edit")
    end

    it "I am brought to a form where I can change any info on the address" do
      click_link 'Edit Address'

      fill_in :nickname, with: "Turing"
      fill_in :name, with: "Ryan Hantak"
      fill_in :street_address, with: "1331 Market Street"
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80202"

      click_button 'Update Address'

      expect(current_path).to eq("/profile/addresses/#{@address_1.id}")

      expect(page).to have_content("Turing")
      expect(page).to have_content("Ryan Hantak")
      expect(page).to have_content("1331 Market Street")
      expect(page).to have_content("Denver")
      expect(page).to have_content("CO")
      expect(page).to have_content("80202")
    end

    it "If I leave fields blank, I see error messages" do
      click_link 'Edit Address'

      fill_in :nickname, with: ""
      fill_in :name, with: ""
      fill_in :street_address, with: ""
      fill_in :city, with: ""
      fill_in :state, with: ""
      fill_in :zip, with: ""

      click_button 'Update Address'

      expect(page).to have_content("Nickname can't be blank, Name can't be blank, Street address can't be blank, City can't be blank, State can't be blank, and Zip can't be blank")
    end
  end
end
