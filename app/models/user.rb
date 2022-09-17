class User
  include Mongoid::Document

  field :nombre_usuario, type: String
  field :contrasena, type: String
  field :rol, type: Array
end
