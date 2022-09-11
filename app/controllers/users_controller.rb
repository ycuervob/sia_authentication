require 'json'

class UsersController < ApplicationController
  before_action :set_user
  include JsonWebToken
  # POST /users
  def get_auth_token
    
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

      begin
        @user = User.find_by(nombre_usuario: decode[:user_id])
        if !@user.auth_token.include?(params[:auth_token])
          return render json: {status: "Token not found"}, status: :unauthorized
        end
              
      rescue => exception
        @user = nil
      end 
      
    else

      begin
        @user = User.find_by(nombre_usuario: params[:nombre_usuario])
        @user.auth_token.delete(params[:auth_token])
        @user.save
      rescue => exception
        @user = nil
        return render json: {status: "User not found"}, status: :unauthorized
      end 

      return render json: {status: "Token not found"}
    end

    if @user != nil
      @user.auth_token.delete(params[:auth_token])
      token = jwt_encode(user_id: @user.nombre_usuario)
      @user.auth_token.push(token)
      @user.save
      render json: {auth_token: token}, status: :ok
    else
      render json: {status: "User or token not found"}
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
