class ApplicationController < ActionController::API  

    private

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit( :contrasena, :nombre_usuario, :rol, :auth_token)
    end
    
end
