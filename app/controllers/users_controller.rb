class UsersController < ApplicationController

	# params[:id] equivalent to User.find(1)
	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		# changed :user to user_params for security
		@user = User.new(user_params) 	# Not the final implementation
		if @user.save
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password,
									 :password_confirmation)
	end
end
