module OrderHelper
	def state_text
		if @order.order_state == 'new'
		 'Process Order'
		elsif @order.order_state == 'in-progress'
			'Deliver'
		elsif @order.order_state == 'delivered'
			'Close Order'	
		end
	end

	def revert_state_text
		if @order.order_state == 'delivered'
			'Revert to In-Progress'
		elsif @order.order_state == 'in-progress'
			'Revert to New'
		end
	end

	def shipping_charge(order)
		shipping_charge = order.shop_profile.shipping_charges.where("minimum_order_cost <= ? and maximum_order_cost >= ?",
			order.order_value, order.order_value).first
		if shipping_charge
			shipping_charge.shipping_cost
		else 
			0
		end
	end
	
	def new_order_count(shop_profile)
		shop_profile.orders.where("order_state='new'").count
	end

	def in_progress_order_count(shop_profile)
		shop_profile.orders.where("order_state='in-progress'").count
	end

	def delevered_order_count(shop_profile)
		shop_profile.orders.where("order_state='delivered'").count 
	end

	def closed_order_count(shop_profile)
		shop_profile.orders.where("order_state='closed'").count
	end


end