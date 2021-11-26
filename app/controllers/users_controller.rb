class UsersController < ApplicationController

  USERS_X_PAGE = 5
  def index
    # @users = User.all
    @page = params.fetch(:page, 0).to_i
    @users = User.offset(@page * USERS_X_PAGE).limit(USERS_X_PAGE)
  end

  def show
    @user = current_user
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
