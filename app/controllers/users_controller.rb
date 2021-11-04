class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    puts '******'
    # @user = User.find_by_id(params[:id])
    @user = current_user
  end
end
