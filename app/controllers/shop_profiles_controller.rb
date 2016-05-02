class ShopProfilesController < ApplicationController
	before_action :authenticate_user!, except: :show
	after_action :verify_authorized, only: :shop_index

	def new
		authorize ShopProfile
		@shop = ShopProfile.new
	end

	def index
		@shops = current_user.shop_profiles
	end

	def show
		@shop_profile = ShopProfile.find(params[:id])
		@items = @shop_profile.shop_products.where(shop_profile_id: @shop_profile.id)
		.paginate(page: params[:page], per_page: 6).search(params[:search])
		if !params[:category_id].nil?
			@items = @shop_profile.shop_products.where(category_id: params[:category_id])
			.paginate(page: params[:page], per_page: 6)
		end
	end

	def create
		authorize ShopProfile
		@shop = ShopProfile.new(shop_params)
		@shop.build_address(address_params_shopkeeper)
		if current_user.shop_profiles << @shop
			flash[:success] = 'Shop Details added'
			redirect_to root_path
		else
			flash[:error] = 'Shop Details not added'
			render 'new'
		end
	end

	def edit
		@shop = current_user.shop_profiles.find(params[:id])
		authorize @shop
	end

	def update
		@shop = current_user.shop_profiles.find(params[:id])
		authorize @shop
		if @shop.update_attributes(shop_params) and @shop.address.update_attributes(address_params_shopkeeper) 
			flash[:success] = 'Updated Successfully'
			redirect_to shop_profiles_path
		else
			flash[:danger] = 'Shop Details not Updated'
			render 'edit'
		end
	end

	def shop_index
		authorize ShopProfile
		respond_to do |format|
      format.html
      format.json {render json: ShopProfileDatatable.new(view_context)}
    end
	end

	def change_status
		authorize ShopProfile
 		@shop = ShopProfile.find(params[:shop_profile_id])
 	  if ! @shop.is_approved
 	  	@shop.is_approved = true
 	  	@shop.save 
 	  	flash[:success] = 'Approved'
 	  	redirect_to request.referrer || root_path
 	  else
 	  	@shop.is_approved = false
 	  	@shop.save 
 	  	flash[:danger] = 'Not Approved'
 	  	redirect_to request.referrer || root_path
 	  end
 	end

	private
	
		def shop_params
			params.require(:shop_profile).permit(:shop_name, :phone_number, :email)
		end

		def address_params_shopkeeper
			params.require(:address).permit(:address_1, :address_2, :city,
																			:state, :pincode, :landmark)
		end

end