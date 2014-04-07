class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
		class_name: "Relationship",
		dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

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

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	private

	def create_remember_token
		self.remember_token = User.hash(User.new_remember_token)
	end
end
