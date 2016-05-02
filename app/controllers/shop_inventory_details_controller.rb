class ShopInventoryDetailsController < ApplicationController
	before_action :authenticate_user!

	def new
		authorize ShopInventoryDetail
   	@shop_product = ShopProduct.find(params[:shop_product_id])
		@shop_inventory_detail = ShopInventoryDetail.new
	end

	def create
		authorize ShopInventoryDetail
		@shop_product = ShopProduct.find_by(id: params[:shop_product_id])
		@shop_inventory_detail = ShopInventoryDetail.new(shop_inventory_detail_params)

		if @shop_product.shop_inventory_details.nil?
			@shop_product.shop_inventory_detail.build
		end			 

		if @shop_product.shop_inventory.nil?
			@shop_product.build_shop_inventory
		end
		@shop_inventory_detail.shop_inventory_id = @shop_product.shop_inventory.id
		@shop_inventory_detail.shop_profile_id = @shop_product.shop_profile.id

		@shop_product.shop_inventory_details << @shop_inventory_detail

		if params[:shop_inventory_detail][:inventory_type] == 'Sale'
			@shop_product.shop_inventory.quantity -= params[:shop_inventory_detail][:quantity].to_f
		elsif params[:shop_inventory_detail][:inventory_type] == 'Purchase'
			@shop_product.shop_inventory.quantity += params[:shop_inventory_detail][:quantity].to_f
		elsif params[:shop_inventory_detail][:inventory_type] == 'Initialization'
			@shop_product.shop_inventory.quantity = params[:shop_inventory_detail][:quantity].to_f
		elsif params[:shop_inventory_detail][:inventory_type] == 'Adjustment'
			@shop_product.shop_inventory.quantity -= params[:shop_inventory_detail][:quantity].to_f				
		end

		if @shop_product.shop_inventory.quantity < 0
			flash[:danger] = 'Insufficient Quantity'
			redirect_to shop_profile_path(@shop_product.shop_profile_id)
		
		elsif @shop_product.shop_inventory.save
		  flash[:success] = 'Inventory details updated'
			redirect_to shop_profile_path(@shop_product.shop_profile_id)
		else
			flash[:danger] = 'Inventory details not added'
			redirect_to shop_profile_path(@shop_product.shop_profile_id)
		end		

	end

	def index
		authorize ShopInventoryDetail
  	@shop_product = ShopProduct.find(params[:shop_product_id])
		@shop_inventory_details = @shop_product.shop_inventory_details
	end


	protected

		def shop_inventory_detail_params
			params.require(:shop_inventory_detail).permit(:inventory_type, :quantity, :notes, :shop_profile_id)
		end

end



