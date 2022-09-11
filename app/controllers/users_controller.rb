class UsersController < ApplicationController
  #before_action only: [:show, :update, :destroy]

  # POST /users
  def get_auth_token
    seach_get_auth = User.where(nombre_usuario: params[:nombre_usuario], contrasena: params[:contrasena])

    #Generate auth token and send it back 
    if seach_get_auth.length() > 0 and seach_get_auth[0].contrasena == params[:contrasena]
      #Look for a token, if not then generate one
      render json: {token: seach_get_auth[0].auth_token}
    else
      render json: '{"status": "User not found"}'
    end
  end

  #check whether the token is equal to the one in BD
  def test_token
    test_auth = User.where(nombre_usuario: params[:nombre_usuario])

    if test_auth.length() > 0
      if params[:auth_token] == "null"
        render json: {access: "false"}
      elsif  params[:auth_token] == test_auth[0].auth_token
        render json: {access: "true"}
      else 
        render json: {access: "false"}
      end   
    else
      render json: '{"status": "User not found"}'
    end
  end 

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:nombre_usuario, :contrasena)
    end
end
