class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:edit,:update,:index, :delete]
	before_filter :correct_user, only: [:edit,:update]
	before_filter :admin_user, only: :destroy

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destoryed."
		redirect_to users_path		
	end

	def index		
		@users = User.paginate(page: params[:page])
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
	        sign_in @user
	        redirect_to @user
		else
			render 'edit'
		end
	end

	def edit
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

  	def new
  		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	private
	  def correct_user
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
      end

      def admin_user
      	redirect_to(root_path) unless current_user.admin?      	
      end
end
