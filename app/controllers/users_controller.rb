class UsersController < ApplicationController
	before_action :signed_in_user, 	only: [:index, :edit, :update, :destroy]
	before_action :correct_user, 	only: [:edit, :update]
	before_action :admin_user, 		only: :destroy

	# Chapter 9 exercise 6
	before_filter :signed_in_user_filter, only: [:new, :create]

	def signed_in_user_filter
		redirect_to root_path, notice: "Already logged in" if signed_in?
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	# params[:id] equivalent to User.find(1)
	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		if signed_in?
			redirect_to root_path
		else
			# changed :user to user_params for security
			@user = User.new(user_params) 	# Not the final implementation
			if @user.save
				sign_in @user
				flash[:success] = "Welcome to the Sample App!"
				redirect_to @user
			else
				render 'new'
			end
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		user = User.find(params[:id])
		unless current_user?(user)
			user.destroy
			flash[:success] = "User deleted."
		else
			flash[:error] = "You can't delete yourself."
		end
		redirect_to users_url
	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :password,
									 :password_confirmation)
	end

	# Before filters

	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end
end
