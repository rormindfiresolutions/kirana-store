class UserProfilesController < ApplicationController
	before_action :authenticate_user!
	
	def new
		@detail = UserProfile.new
	end

	def create
		@detail = current_user.build_user_profile(user_params)
		if current_user.customer? and @detail.save(validate: false)
			flash[:success] = 'User details added'
			redirect_to root_path
		elsif current_user.shopkeeper? and @detail.save
			flash[:success] = 'User details added'
			redirect_to root_path
		else
			render 'new'
		end
	end

	private
		def user_params
			params.require(:user_profile).permit(:first_name, :last_name, :phone_number, :email)
		end
end