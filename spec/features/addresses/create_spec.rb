require 'rails_helper'

RSpec.describe 'User addresses creation' do
  describe 'As a user, when I navigate to my addresses index page' do
    before(:each) do
      @user = User.create(name: 'Ryan', email: 'ryan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile'
      click_link 'My Addresses'
    end

    it "I see a link to add a new address" do
      expect(page).to have_link 'Add Address'

      click_link 'Add Address'
      expect(current_path).to eq('/profile/addresses/new')
    end

    it "I see a form I can fill in to create a new address on my account" do
      click_link 'Add Address'

      fill_in :nickname, with: "Turing"
      fill_in :name, with: "Ryan Hantak"
      fill_in :street_address, with: "1331 Market Street"
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: "80202"

      click_button 'Create Address'

      expect(current_path).to eq('/profile/addresses')

      expect(page).to have_content("Turing")
      expect(page).to have_content("Ryan Hantak")
      expect(page).to have_content("1331 Market Street")
      expect(page).to have_content("Denver")
      expect(page).to have_content("CO")
      expect(page).to have_content("80202")
    end

    it "I see error messages if I leave any information blank" do
      click_link 'Add Address'
      click_button 'Create Address'

      expect(page).to have_content("Nickname can't be blank, Name can't be blank, Street address can't be blank, City can't be blank, State can't be blank, and Zip can't be blank")
    end
  end
end
