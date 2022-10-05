json.users @users do |user|
    json.nombre_usuario user.nombre_usuario
    json.contrasena user.contrasena
    json.rol user.rol
end