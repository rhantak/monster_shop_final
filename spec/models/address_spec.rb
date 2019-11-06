require 'rails_helper'

RSpec.describe Address do
  describe 'Relationships' do
    it {should belong_to :user}
    it {should have_many :orders }
  end

  describe 'Validations' do
    it {should validate_presence_of :nickname}
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
  end

  describe 'instance methods' do
    it 'none_shipped?' do
      @user = User.create!(name: 'Ryan', email: 'ryan@ryan.com', password: 'securepassword')

      @address_1 = Address.create(nickname: 'Home', name: 'Ryan Hantak', street_address: '123 A Street', city: 'Dallas', state: 'TX', zip: '75070', user_id: @user.id)
      @address_2 = Address.create(nickname: 'Work', name: 'Ryan Hantak', street_address: '234 B Street', city: 'Denver', state: 'CO', zip: '80202', user_id: @user.id)

      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @order_1 = @user.orders.create!(status: "shipped", address_id: @address_1.id)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)

      expect(@address_1.none_shipped?).to eq(false)
      expect(@address_2.none_shipped?).to eq(true)
    end
  end
end
