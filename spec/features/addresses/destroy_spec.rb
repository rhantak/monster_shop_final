require 'rails_helper'

RSpec.describe 'User addresses can be deleted' do
  describe 'As a user, when I visit an address show page' do
    before(:each) do
      @user = User.create(name: 'Ryan', email: 'ryan@example.com', password: 'securepassword')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = Address.create(nickname: 'Home Address', name: 'Ryan Hantak', street_address: '123 A Street', city: 'Dallas', state: 'TX', zip: '75070', user_id: @user.id)
      @address_2 = Address.create(nickname: 'Work', name: 'Ryan Hantak', street_address: '234 B Street', city: 'Denver', state: 'CO', zip: '80202', user_id: @user.id)
      @address_3 = Address.create(nickname: 'Other Home', name: 'Ryan Hantak', street_address: '345 C Street', city: 'Tucson', state: 'AZ', zip: '70707', user_id: @user.id)

      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @order_1 = @user.orders.create!(status: "shipped", address_id: @address_1.id)
      @order_2 = @user.orders.create!(status: "pending", address_id: @address_3.id)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)

      visit '/profile'
      click_link 'My Addresses'
    end

    it "I see a link to delete that address" do
      within "#address-#{@address_2.id}" do
        click_link "#{@address_2.nickname}"
      end

      expect(page).to have_button('Delete Address')
    end

    it "If that address has no orders attached to it, I can delete it" do
      within "#address-#{@address_2.id}" do
        click_link "#{@address_2.nickname}"
      end

      click_button 'Delete Address'
      expect(current_path).to eq('/profile/addresses')
      expect(page).to_not have_content(@address_2.nickname)
      expect(page).to_not have_content(@address_2.street_address)
      expect(page).to_not have_content(@address_2.city)
      expect(page).to_not have_content(@address_2.state)
      expect(page).to_not have_content(@address_2.zip)
    end

    it "If that address has orders pending or packaged to it, I see a message that I need to change their destination" do
      within "#address-#{@address_3.id}" do
        click_link "#{@address_3.nickname}"
      end

      click_button 'Delete Address'

      expect(page).to have_content("You have order(s) going to this address! Please change their destination(s) before deleting this address.")
    end

    it "If that address has orders shipped to it, I don't see a button to delete it" do
      within "#address-#{@address_1.id}" do
        click_link "#{@address_1.nickname}"
      end

      expect(page).to_not have_button('Delete Address')
    end
  end
end
