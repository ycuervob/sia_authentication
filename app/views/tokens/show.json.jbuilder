json.auth_token @token
json.rol (@user&.rol || @decode[:user_rol])
json.nombre_usuario (@user&.nombre_usuario || @decode[:user_id])