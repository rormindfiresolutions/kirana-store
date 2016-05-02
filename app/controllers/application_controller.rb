class ApplicationController < ActionController::Base

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user

  def after_sign_in_path_for(user)
    if user.sign_in_count == 1 and current_user.customer?
      new_user_profile_path
    elsif current_user.shopkeeper? and user.user_profile.nil?
      new_user_profile_path
    else
      root_path
    end
  end

  def current_user
    super or guest_user
  end

  private

    def guest_user
      User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
    end

    def create_guest_user
      user = User.new { |user| user.role = 'guest' }
      user.email = "guest_#{Time.now.to_i}#{rand(99)}@example.com"
      user.save(validate: false)
      user
    end

    def user_not_authorized
      flash[:danger] = "Access denied."
      redirect_to (request.referrer || root_path)
    end

    def record_not_found
      flash[:danger] = 'Record Not Found'
      redirect_to (request.referrer || root_path)
    end

    def no_routes_found
      flash[:danger] = 'Invalid Route'
      redirect_to root_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:password, :role, :email) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation,
                                                       :current_password, :first_name, :last_name, :phone_number) } 
    end
end


