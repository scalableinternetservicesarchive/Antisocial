class UsersController < ApplicationController

  USERS_X_PAGE = 5
  def index
    # @users = User.all
    @page = params.fetch(:page, 0).to_i
    @users = User.order(created_at: :desc).offset(@page * USERS_X_PAGE).limit(USERS_X_PAGE)
  end

  def show
    @user = current_user
    @page = params.fetch(:page, 0).to_i
    @friends = current_user.friendships.offset(@page * USERS_X_PAGE).limit(USERS_X_PAGE)
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments
  end

  def profiles
    @user = User.find(params[:id])
    @profile = @user.comments
  end

end
