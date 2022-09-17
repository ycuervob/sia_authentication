class ApplicationController < ActionController::API  

    private
    
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit( :contrasena, :nombre_usuario, :rol,:auth_token)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find_by(nombre_usuario: params[:id])
      rescue => exception
        @user = nil
      end    
    end
    
end
