class Product < ActiveRecord::Base
	has_many :shop_products
	belongs_to :brand
	belongs_to :category

	def self.search(search)
	  if search
	    where("product_name like ?", "%#{search}%")
	  else
	    all
	  end
	end

end
