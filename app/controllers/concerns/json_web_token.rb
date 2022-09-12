require "jwt"

module JsonWebToken
    extend ActiveSupport::Concern
    
    SECRET_KEY = Rails.application.secret_key_base

    def jwt_encode (payload, exp = Time.now.to_i + 900)
        timestamp = p DateTime.now.strftime('%Q')
        payload[:exp] = exp.to_i
        payload[:timestamp] = timestamp
        JWT.encode(payload, SECRET_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    rescue
        nil
    end

end