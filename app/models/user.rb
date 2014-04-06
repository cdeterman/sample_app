class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy

	# before saving, convert email to lowercase
	before_save { self.email = email.downcase }
	before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 }
	
	# validate email format
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }

	# password validation
	has_secure_password

	validates :password, length: { minimum: 6 }

	# remember tokens
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.hash(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	# the ? escapes the id before including in SQL query
	# good practice as improves security of queries
	def feed
		Micropost.where("user_id = ?", id)
	end

	private

	def create_remember_token
		self.remember_token = User.hash(User.new_remember_token)
	end
end
