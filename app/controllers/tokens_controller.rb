require 'json'

class TokensController < ApplicationController
  before_action :set_user, :user_params
  include JsonWebToken

  # POST /auth
  def get_auth_token
    if @user&.contrasena == params[:contrasena]
      token = jwt_encode(user_id: @user.nombre_usuario)
      render json: {auth_token: token, rol: @user.rol}, status: :ok    
    else
      render json: {status: "User not found"}
    end
  end

  #POST /auth/refresh
  #check whether the token is equal to the one in BD
  def test_token
    decode = jwt_decode(params[:auth_token]) 
    if decode != nil
      token = jwt_encode(user_id: decode[:user_id])
      render json: {auth_token: token, rol: @user.rol}, status: :ok
    else
      render json: {status: "User or token not found"}, status: :unauthorized
    end
  end 

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:nombre_usuario, :contrasena, :auth_token)
    end

    def set_user(user_name = params[:nombre_usuario])
      begin
        @user = User.find_by(nombre_usuario: user_name)
      rescue => exception
        @user = nil
      end     
    end
end
