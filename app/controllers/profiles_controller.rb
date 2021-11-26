class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]

  # GET /profiles or /profiles.json
  def index
    puts "profile"
    puts current_user.id
    @profiles = Profile.where(user_id: current_user.id)
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    id = params[:id]
    @profile = Profile.find_by user_id: id
  end

  # GET /profiles/new
  def new

    if Profile.exists?(user_id: current_user.id)
      redirect_to(root_path)
    else
      @profile = Profile.new
    end

  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find_by user_id: current_user.id
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    @profile = Profile.find_by user_id: current_user.id
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    redirect_to(root_path)
    #@profile = Profile.where("user_id": current_user.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      #@profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :about, :address)
    end
end
