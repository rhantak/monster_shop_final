class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :nickname,
                         :name,
                         :street_address,
                         :city,
                         :state,
                         :zip

  def none_shipped?
    (orders.where(status: "shipped")).empty?
  end
end
