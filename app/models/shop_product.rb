class ShopProduct < ActiveRecord::Base
	has_one :shop_inventory
	has_many :shop_inventory_details
	belongs_to :shop_profile
	belongs_to :product
	belongs_to :category
	belongs_to :user_basket

	def self.search(search)
	  if search
	    where("product_name like ? or brand_name like ?", "%#{search}%", "%#{search}%")
	  else
	    all
	  end
	end	

	validates :selling_price, numericality: { greater_than_or_equal_to: 0 }
	validates :mrp, numericality: { greater_than_or_equal_to: 0 }

end

