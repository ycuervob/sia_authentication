require "net/ldap" 
module LdapAuth
    extend ActiveSupport::Concern

    def name_for_login( user, password )
        user = user[/\A\w+/].downcase  # Throw out the domain, if it was there
        mydn = "cn=#{user},ou=sa,dc=sia,dc=unal,dc=edu,dc=co"        # I only check people in my company
        ldap = Net::LDAP.new
        ldap.host = "localhost"
        ldap.port = 389
        ldap.auth mydn, password
        if ldap.bind
            return true
        end
        raise "User not found LDAP"
    end

end 