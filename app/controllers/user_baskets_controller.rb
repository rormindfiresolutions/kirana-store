class UserBasketsController < ApplicationController
	before_action :check_own_shop, only: :create


	def create
		shop_product = ShopProduct.find_by(id: params[:id])
		shop_profile = ShopProfile.find_by(id: params[:id])
		item = UserBasket.where(shop_product_id: shop_product.id, user_id: current_user.id).first

		if shop_product.shop_inventory.quantity == 0
			flash[:danger] = 'Insufficient Quantity'
			redirect_to request.referrer  and return
		end

		if item 
			item.increment!(:quantity, 1.0)
			save_user_basket(item)
		else
			@user_basket = UserBasket.new
			@user_basket = current_user.user_baskets.build
			@user_basket.quantity = 1
			@user_basket.shop_product_id = shop_product.id
			@user_basket.shop_profile_id = shop_product.shop_profile.id
			save_user_basket(@user_basket)
		end

	end

	def edit
		if current_user.user_baskets.empty?
			flash[:error] = 'Your Cart is Empty'
			redirect_to request.referrer || root_path
		else
			@user_baskets = UserBasket.all.where(user_id: current_user.id)
		end
	end

	def edit_quantity
		@user_basket = UserBasket.find(params[:id])
	end

	def update_quantity
		@user_basket = UserBasket.find(params[:id])
		shop_product = ShopProduct.find_by(id: @user_basket.shop_product_id)
	  @user_basket.quantity = params[:user_basket][:quantity].to_f

	  if shop_product.shop_inventory.quantity - @user_basket.quantity < 0
			flash[:danger] = 'Insufficient Quantity'
			redirect_to edit_user_basket_path  and return
		end

		if @user_basket.update_attributes(user_baskets_params)
			flash[:success] = 'Quantity Updated'
			redirect_to edit_user_basket_path
		else
		  flash[:danger] = 'Not Updated'
			redirect_to edit_user_basket_path
		end	
	end


	def destroy
		@user_basket = UserBasket.find(params[:id])
		@user_basket.destroy
		if current_user.user_baskets.empty?
			redirect_to root_path
		else
			redirect_to request.referrer || root_path
		end
	end

	private

		def user_baskets_params
			params.require(:user_basket).permit(:quantity, :user_id, :shop_product_id, :shop_profile_id, :shipping_cost)
		end

		def save_user_basket(item)
			if item.save 
				flash[:success] = 'Product Added to Cart'
				redirect_to request.referrer || root_path
			else
				flash[:error] = 'Product not Added'
				redirect_to request.referrer || root_path
			end
		end

		def check_own_shop
			shop_product = ShopProduct.find_by(id: params[:id])
			current_user.shop_profiles.each do |current_shop_profile|
				if current_shop_profile == ShopProfile.where(id: shop_product.shop_profile_id).first
					flash[:danger] = 'You cannot add your own products to basket'
					redirect_to request.referer || root_path 
				end
			end
		end
		
end
