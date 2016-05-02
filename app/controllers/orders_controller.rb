class OrdersController < ApplicationController

	def edit
		@order = Order.find_by(id: params[:id])
		authorize @order
		change_order_state
	end

	def update
	end

	def show
		@order = Order.find_by(id: params[:id])
		authorize @order
		user = User.find_by(id: params[:id])
		user_profile = UserProfile.find_by(id: params[:id])
		respond_to do |format|
      format.html
      format.pdf do
       	pdf = WickedPdf.new.pdf_from_string(render_to_string('orders/show.pdf.erb', layout: 'pdf'))
       	send_data(pdf, filename: "#{@order.user.user_profile.first_name}.pdf")
      end
    end
	end

	def index
		if current_user.customer?
			if params[:list] =='All'
				@orders = current_user.orders.order(created_at: :desc)
			else
			  @orders = current_user.orders.order(created_at: :desc).where(:created_at => (Time.now - 1.month)..Time.now)
			end
		else
			@shop_profile = ShopProfile.find_by(id: params[:shop_profile_id])
			order_state = params[:order_state]
			if order_state == 'own'
				@orders = current_user.orders.order(created_at: :desc)
			else
				@orders = @shop_profile.orders.where(order_state: order_state)
			end
			authorize @shop_profile
		end
		authorize @orders
	end

	def change_order_state
		if @order.order_state == 'new'
		 @order.order_state = 'in-progress'
		elsif @order.order_state == 'in-progress'
			@order.order_state = 'delivered'
		elsif @order.order_state == 'delivered'
			@order.order_state = 'closed'
		end			
		if @order.save
			flash[:success] = 'Order State Changed'
			redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
		else
			flash[:danger] = 'Error While Changing State'
			redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
		end
	end

	def revert_order_state
		@order = Order.find(params[:order_id])
		authorize @order
		if @order.order_state == 'delivered'
		 @order.order_state = 'in-progress'
		elsif @order.order_state == 'in-progress'
			@order.order_state = 'new'
		end			
		if @order.save
			flash[:success] = 'Order State Reverted'
			redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
		else
			flash[:danger] = 'Error While Reverting State'
			redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
		end	
	end

	def cancel_order
		@order = Order.find(params[:order_id])
		@order.order_lines.each do |product|
			shop_product = product.shop_product
			add_cancellation_to_inventory_details(shop_product, product)
		end
		@order.order_state = 'closed'
		if @order.save
			flash[:success] = 'Order Successfully Cancelled'
			redirect_to orders_path(shop_profile_id: @order.shop_profile_id)
		else
			flash[:danger] = "Order not Cancelled"
			redirect_to order_path(@order)
		end	
	end

	private
		def add_cancellation_to_inventory_details(shop_product, product)
			shop_inventory_detail = ShopInventoryDetail.new
			if shop_product.shop_inventory.nil?
				shop_product.build_shop_inventory
			end
			shop_product.shop_inventory.quantity += product.quantity
			shop_inventory_detail.quantity = product.quantity
			shop_inventory_detail.inventory_type = 'Adjust'
			shop_inventory_detail.notes = 'Cancelled'
			shop_inventory_detail.shop_product_id = shop_product.id
			shop_inventory_detail.shop_profile_id = shop_product.shop_profile_id
			shop_product.shop_inventory.shop_inventory_details <<  shop_inventory_detail
			shop_product.shop_inventory.save
		end
	
end
