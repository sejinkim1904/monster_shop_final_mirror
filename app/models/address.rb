class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :address_name
  validates :address_name, uniqueness: {:scope => :user_id}
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip

  validates :zip, numericality: true

  def shipped_orders
    orders.where(status: "shipped", address_id: id)
  end
end
