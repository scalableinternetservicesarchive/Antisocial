class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = current_user
    @friends = current_user.friendships.order(created_at: :desc)
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
  end

end
