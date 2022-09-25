require 'json'

class TokensController < ApplicationController
  before_action :set_user
  include JsonWebToken

  # POST /auth
  def get_auth_token
    if @user&.contrasena == params[:contrasena]
      token = jwt_encode(user_id: @user.nombre_usuario, user_rol: @user.rol)
      render json: {auth_token: token, rol: @user.rol}, status: :ok    
    else
      render json: {status: "User not found"}
    end
  end

  #POST /auth/refresh
  def test_token
    decode = jwt_decode(params[:auth_token]) 
    if decode != nil
      token = jwt_encode(user_id: decode[:user_id], user_rol: decode[:user_rol])
      render json: {auth_token: token, rol: decode[:user_rol] , nombre_usuario: decode[:user_id]}, status: :ok
    else
      render json: {status: "User or token not found"}, status: :unauthorized
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find_by(nombre_usuario: params[:nombre_usuario])
      rescue => exception
        @user = nil
      end    
    end

end
