require 'json'

class UsersController < ApplicationController
  #before_action only: [:show, :update, :destroy]

  include JsonWebToken

  # POST /users
  def get_auth_token
    
    seach_get_auth = User.where(nombre_usuario: params[:nombre_usuario])

    #Generate auth token and send it back 
    if seach_get_auth.length() > 0 and seach_get_auth[0].contrasena == params[:contrasena]
      
      #Look for a token, if not then generate one and store it the db
      token = jwt_encode(user_id: seach_get_auth[0].nombre_usuario)
      if seach_get_auth[0].auth_token == nil
          seach_get_auth[0].update({auth_token: [token]})
          render json: {token: token}, status: :ok
      else         
          render json: {status: seach_get_auth[0].auth_token}
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
      test_auth = User.where(nombre_usuario: decode[:user_id])
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
      render json: '{"status": "User not found"}'
    end
  end 

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:nombre_usuario, :contrasena, :token)
    end
end
