class User 
  include Mongoid::Document
  field :nombre_usuario, type: String
  field :contrasena, type: String
  field :auth_token, type: String
end
