class CreateAddress < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :nickname
      t.string :name
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
