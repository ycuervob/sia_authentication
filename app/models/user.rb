class User
  include Mongoid::Document

  field :nombre_usuario, type: String
  field :contrasena, type: String
  field :rol, type: Array
  index({ nombre_usuario: 1 }, { unique: true , name: "ssn_index" })
end
