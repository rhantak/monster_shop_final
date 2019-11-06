require 'rails_helper'

RSpec.describe 'Edit order' do
  describe 'As a registered user' do
    describe 'When I vist an order show page' do
      before(:each) do
        @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
        @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
        @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
        @address_1 = Address.create!(nickname: 'Home', name: 'Megan', street_address: '123 A Street', city: 'Dallas', state: 'TX', zip: '75070', user_id: @user.id)
        @address_2 = Address.create!(nickname: 'New Address', name: 'Megan', street_address: '234 Street', city: 'Denver', state: 'CO', zip: '80202', user_id: @user.id)
        @order_1 = @user.orders.create!(status: "packaged", address_id: @address_1.id)
        @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
        visit '/profile'
        click_link 'My Orders'
        click_link "#{@order_1.id}"
      end

      it "I see a link to edit the order if it is not shipped" do
        click_link 'Edit Order'

        expect(current_path).to eq("/profile/orders/#{@order_1.id}/edit")
      end

      it "I don't see an edit link if the order has shipped" do
        @order_1.update(status: 'shipped')
        visit '/profile'
        click_link 'My Orders'
        click_link "#{@order_1.id}"

        expect(page).to_not have_link('Edit Order')
      end

      it "I can select an option for a new address" do
        click_link 'Edit Order'

        find('#order_address_id').find(:xpath, 'option[2]').select_option

        click_button 'Change Address'

        visit '/profile/orders'
        click_link "#{@order_1.id}"
        expect(page).to have_content(@address_2.street_address)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
      end
    end
  end
end
