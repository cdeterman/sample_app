class User < ActiveRecord::Base
	# before saving, convert email to lowercase
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	
	# validate email format
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }

	# password validation
	has_secure_password

	validates :password, length: { minimum: 6 }
end
