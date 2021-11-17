class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = current_user
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end

end
