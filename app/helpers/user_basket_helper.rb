module UserBasketHelper

	def shipping_charge(shop,cost)
		shop_profile = ShopProfile.find(shop.shop_profile_id)
		shop_profile.shipping_charges.where("minimum_order_cost <= ? and maximum_order_cost >= ?",cost,cost).first.shipping_cost
	end

	def find_shipping_charge(shop,cost)
		shop_profile = ShopProfile.find(shop.shop_profile_id)
		temp = true
		shop_profile.shipping_charges.each do |f|
		  if cost.between?(f.minimum_order_cost, f.maximum_order_cost)
		  	temp = false
	 		end
		end
		return temp
	end

end
