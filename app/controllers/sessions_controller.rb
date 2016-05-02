class SessionsController < Devise::SessionsController
	after_action :transfer_guest_information, only: [:create]

	private

	def transfer_guest_information
	  if session[:guest_user_id]
	    guest = User.find(session[:guest_user_id])
	    guest.move_to(current_user)
	    guest.destroy
	  end
	end

end
