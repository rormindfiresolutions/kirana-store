class ShopInventoryDetail < ActiveRecord::Base
	belongs_to :shop_inventory
	belongs_to :shop_product
	belongs_to :shop_profile

	validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
