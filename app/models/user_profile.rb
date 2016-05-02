class UserProfile < ActiveRecord::Base
	belongs_to :user

	nilify_blanks only: [:first_name, :last_name, :phone_number, :email]

	VALID_NAME_REGEX = /\A[a-zA-Z]+\z/
	validates :first_name, length: { minimum: 3, maximum: 30 }, format: { with: VALID_NAME_REGEX }
	validates :last_name, length: { minimum: 3, maximum: 30 }, format: { with: VALID_NAME_REGEX }
	validates :phone_number, length: { is: 10 }, numericality: { only_integer: true }
	# VALID_EMAIL_REGEX = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/
	# validates :email, format: { with: VALID_EMAIL_REGEX }
	validates_format_of :email, with: Devise::email_regexp
end
