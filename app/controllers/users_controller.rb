class UsersController < ApplicationController
  before_action :set_user, only: [:create, :show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create

    if user_params[:contrasena].nil? || user_params[:nombre_usuario].nil? || user_params[:rol].nil?
      return render json: {error: "Bad data"}, status: :unprocessable_entity 
    end

    @user = User.new(user_params)

    begin
      @user.save
      render json: @user, status: :created, location: @user
    rescue => exception
      render json: {error: exception}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find_by(nombre_usuario: params[:id])
      rescue => exception
        @user = nil
      end    
    end
end
