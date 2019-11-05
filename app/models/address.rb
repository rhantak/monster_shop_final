class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :nickname,
                         :name,
                         :street_address,
                         :city,
                         :state,
                         :zip
end
