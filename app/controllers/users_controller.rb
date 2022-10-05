class UsersController < ApplicationController
  before_action :set_user, only: [:create, :show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render :index
  end

  # GET /users/1
  def show
    render :show
  end

  # POST /users
  def create

    if user_params[:contrasena].nil? || user_params[:nombre_usuario].nil? || user_params[:rol].nil?
      @exception = "Bad data"
      return render :error, status: :unprocessable_entity 
    end

    @user = User.new(user_params)

    begin
      @user.save
      render :show, status: :created, location: @user
    rescue => exception
      @exception = exception
      render :error, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if !@user.nil?
      @user.update(user_params)
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if !@user.nil?
      @user.destroy
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find_by(nombre_usuario: params[:id])
      rescue => exception
        @exception = "not user " + params[:id] 
      end    
    end
end
