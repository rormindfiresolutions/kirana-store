class UserBasket < ActiveRecord::Base
	belongs_to :user
	has_many :shop_products

	validates :quantity, numericality: { greater_than: 0 }
end
