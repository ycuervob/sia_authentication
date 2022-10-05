require 'json'

class TokensController < ApplicationController
  before_action :set_user
  include JsonWebToken

  # POST /auth
  def get_auth_token
    if @user&.contrasena == params[:contrasena]
      @token = jwt_encode(user_id: @user.nombre_usuario, user_rol: @user.rol)
      render :show, status: :ok    
    else
      render :error, status: :unauthorized
    end
  end

  #POST /auth/refresh
  def test_token
    @decode = jwt_decode(params[:auth_token]) 
    if @decode != nil
      @token = jwt_encode(user_id: @decode[:user_id], user_rol: @decode[:user_rol])
      render :show, status: :ok
    else
      render :error, status: :unauthorized
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
