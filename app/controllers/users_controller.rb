require 'json'

class UsersController < ApplicationController
  before_action :set_user
  include JsonWebToken
  # POST /users
  def create
    
    #@user = User.find_by(nombre_usuario: params[:nombre_usuario])
    #Generate auth token and send it back 
    if @user != nil
      if @user.contrasena == params[:contrasena]
        #Look for a token, if not then generate one and store it the db
        token = jwt_encode(user_id: @user.nombre_usuario)
    
        if !@user.auth_token? 
          @user.auth_token = []
        end

        @user.auth_token.push(token)
        @user.save
        render json: {token: token}, status: :ok         
        else
          render json: {status: "User not found"}
        end
      else
        render json: {status: "User not found"}
      end
  end

  #POST /auth
  #check whether the token is equal to the one in BD
  def test_token
    decode = jwt_decode(params[:auth_token])
    if decode != nil
      test_auth = User.where(nombre_usuario: decode[:user_id])[0]
    else
      test_auth =[]
    end

    if test_auth.length() > 0
      token = jwt_encode(user_id: test_auth[0].nombre_usuario)
      test_auth[0].update({auth_token: [token]})
      render json: {token: token}, status: :ok
    else
      test_auth = User.where(nombre_usuario: params[:nombre_usuario])
      test_auth[0].unset(:auth_token)
      render json: {status: "authentication required"}, status: :unauthorized
    end
  end 

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:nombre_usuario, :contrasena, :token)
    end

    def set_user
      begin
        @user = User.find_by(nombre_usuario: params[:nombre_usuario])
      rescue => exception
        @user = nil
      end     
    end
end
